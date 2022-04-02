require "spec_helper"

module Decidim::VocacityGemTasks
  describe Seed do
    subject { described_class }
    before(:each) do
      DatabaseCleaner.clean
    end
    let(:valid_options) do
      {
          "system_admin_email": "system_admin_email@example.com",
          "system_admin_password": "system_admin_password",
          "admin_email": "admin@example.com",
          "org_name": "org_name",
          "org_prefix": "org_prefix",
          "host": "host",
          "default_locale": "en",
          "available_locales": "en,es"
      }
    end

    it "creates a system administrator with given attributes system_admin_email, system_admin_password" do
      expect do
        subject.seed!(valid_options)
      end.to change { Decidim::System::Admin.count }.from(0).to(1)
      expect(Decidim::System::Admin.first.email).to eq "system_admin_email@example.com"
    end

    it "creates an organization with given attribute org_name, host, org_prefix" do
      expect do
        subject.seed!(valid_options)
      end.to change { Decidim::Organization.count }.from(0).to(1)
      expect(Decidim::Organization.first.host).to eq "host"
      expect(Decidim::Organization.first.name).to eq "org_name"
      expect(Decidim::Organization.first.reference_prefix).to eq "org_prefix"
    end

    it "defines basic content blocks" do
      expect do
        subject.seed!(valid_options)
      end.to change { Decidim::ContentBlock.count }.by_at_least(2)
    end

    it "creates a help page" do
      expect do
        subject.seed!(valid_options)
      end.to change { Decidim::StaticPage.where(slug: "help").count }.from(0).to(1)
    end

    it "creates a term and conditions page" do
      expect do
        subject.seed!(valid_options)
      end.to change { Decidim::StaticPage.where(slug: "terms-and-conditions").count}.by(1)
    end

    describe "admin creation:" do
      it "creates an admin" do
        expect do
          subject.seed!(valid_options)
        end.to change { Decidim::User.where(admin: true).count }.from(0).to(1)
      end

      it "send a webhook to the main service with credentials" do
        expect(Decidim::VocacityGemTasks::WebhookNotifierJob).to receive(:perform_later).with(
          {
            id: 1,
            email: "admin@example.com",
            password: anything,
            nickname: "admin",
            name: "Admin",
            level: "info"
          },
          "decidim.admin_created"
        )
        subject.seed!(valid_options)
      end
    end
  end
end
