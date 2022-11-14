# frozen_string_literal: true

require "spec_helper"

module Decidim::Voca
  describe Decidim::Voca::DecidimServiceController do
    let(:empty) { ::Google::Protobuf::Empty.new }
    
    def subject(options)
      run_rpc(
        :SeedAdmin,
        ::VocaDecidim::SeedAdminRequest.new(options)
      )
    end

    let(:net_stub) do
      class NetStub; end
      net_stub = NetStub.new
      allow(net_stub).to receive(:post)
      net_stub
    end

    before(:each) do
      http_net = class_double("Net::HTTP").as_stubbed_const()
      allow(http_net).to receive(:new).and_return(net_stub)
      DatabaseCleaner.clean
      ::Decidim::Organization.create!(
        host: "localhost",
        name: "parked instance",
        default_locale: :en,
        available_locales: [:en],
        reference_prefix: "DOC",
        available_authorizations: [],
        users_registration_mode: :enabled,
        tos_version: Time.current,
        badges_enabled: true,
        user_groups_enabled: true,
        send_welcome_notification: true,
        file_upload_settings: ::Decidim::OrganizationSettings.default(:upload)
      )
    end

    let(:valid_options) do
      {
          system_email: "system_admin_email@example.com",
          system_password: "system_admin_password",
          admin_email: "admin@example.com"
      }
    end

    it "creates a system administrator with given attributes system_admin_email, system_admin_password" do
      expect do
        subject(valid_options)
      end.to change { Decidim::System::Admin.count }.from(0).to(1)
      expect(Decidim::System::Admin.first.email).to eq "system_admin_email@example.com"
    end

    describe "admin creation:" do

      it "creates an admin" do
        expect do
          subject(valid_options)
        end.to change { Decidim::User.where(admin: true).count }.from(0).to(1)
      end

      it "returns admin credential" do 
        response = subject(valid_options)
        expect(response.admin_email).to eq("admin@example.com")
        expect(response.admin_password.size).to be > 0
      end
    end
  end
end
