require "spec_helper"

module Decidim::VocacityGemTasks
  describe SystemUpdater do
    subject { described_class.new }
    let(:organization) { Decidim::Organization.first }

    before(:each) do
      DatabaseCleaner.clean
      create(:organization)
    end

    describe ".naming" do
      it "updates the organization host and secondary_host" do
        expect do
         expect do
           subject.naming(host: "voca.city", secondary_host: "hello.world")
           organization.reload
         end.to change(organization, :host).to "voca.city"
       end.to change(organization, :secondary_hosts).to(["hello.world"])
      end

      it "updates the organization name and reference" do
        expect do
         expect do
           subject.naming(name: "VocaCity", reference_prefix: "VOCA")
           organization.reload
         end.to change(organization, :name).to "VocaCity"
       end.to change(organization, :reference_prefix).to("VOCA")
      end
    end

    describe ".locales" do
      it "updates the organization language and availables languages" do
        expect do
         expect do
           subject.locales(available: ["en", "ca"], default: "ca")
           organization.reload
         end.to change(organization, :default_locale).to "ca"
       end.to change(organization, :available_locales).to(["en", "ca"])
      end

      it "rebuild the search index" do
        expect(Rake::Task["decidim:locales:rebuild_search"]).to receive(:invoke)
        subject.locales(default: "es")
      end

      it "fails if no default locale is given" do
        expect do
          subject.locales(available: [:ca])
        end.to raise_error(Error)
      end

      it "if no available locales given, take [default] as default" do
        expect do
         expect do
           subject.locales(default: "es")
           organization.reload
         end.to change(organization, :default_locale).to "es"
       end.to change(organization, :available_locales).to(["es"])
      end
    end

    describe ".feature" do
      describe "registration_mode" do
      it "enabled: Can enable users registration and sign in" do
        subject.features(registration_mode: "enabled")
        organization.reload
        expect(organization).to be_sign_up_enabled
        expect(organization).to be_sign_in_enabled
      end
      it "existing: Can enable user sign in with no registration" do
        subject.features(registration_mode: "existing")
        organization.reload
        expect(organization).not_to be_sign_up_enabled
        expect(organization).to be_sign_in_enabled
      end
      it "disabled: Can block sign in and registration" do
        subject.features(registration_mode: "disabled")
        organization.reload
        expect(organization).not_to be_sign_up_enabled
        expect(organization).not_to be_sign_in_enabled
      end
    end

      it "enable/disable badges" do
        expect do
          subject.features(badges: "disabled")
          organization.reload
        end.to change(organization, :badges_enabled).to eq(false)

        expect do
          subject.features(badges: "enabled")
          organization.reload
        end.to change(organization, :badges_enabled).to eq(true)
      end
      it "enable/disable users groups" do

        expect do
          subject.features(user_groups: "disabled")
          organization.reload
        end.to change(organization, :user_groups_enabled).to eq(false)

        expect do
          subject.features(user_groups: "enabled")
          organization.reload
        end.to change(organization, :user_groups_enabled).to eq(true)

      end
    end
  end
end
