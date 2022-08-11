require "spec_helper"

describe Decidim::Voca::GetSettingsController do
  let(:empty) { ::Google::Protobuf::Empty.new }
  context "edge cases" do
    it "raises not found error if no organization is present" do
      expect do
        run_rpc(:GetSettings, empty)
      end.to raise_rpc_error(GRPC::NotFound)
    end
  end

  context "with a valid organization" do
    let(:organization) do
      create(
        :organization,
          default_locale: :es,
          available_locales: [:es],
          official_img_header: nil,
          official_img_footer: nil,
          favicon: nil
        )
    end
    before(:each) { organization }
    subject do
      run_rpc(
        :GetSettings,
        empty
      )
    end

    it("returns the id") { expect(subject.id).to eq(organization.id) }

    context ".permission_settings" do
      let(:perm) { subject.permission_settings }
      it("force_users_to_authenticate_before_access_organization") do
        expect(perm.force_users_to_authenticate_before_access_organization).to eq(organization.force_users_to_authenticate_before_access_organization)
      end
      context "users_registration_mode" do
        it("SETTINGS_REGISTER_MODE_REGISTER_AND_LOGIN if enabled") do
          organization.update(users_registration_mode: "enabled")
          expect(perm.users_registration_mode).to eq(:SETTINGS_REGISTER_MODE_REGISTER_AND_LOGIN)
        end
        it(":SETTINGS_REGISTER_MODE_LOGIN if existing") do
          organization.update(users_registration_mode: "existing")
          expect(perm.users_registration_mode).to eq(:SETTINGS_REGISTER_MODE_LOGIN)
        end
        it(":SETTINGS_REGISTER_MODE_EXTERNAL if disabled") do
          organization.update(users_registration_mode: "disabled")
          expect(perm.users_registration_mode).to eq(:SETTINGS_REGISTER_MODE_EXTERNAL)
        end
      end
    end

    context ".naming_settings" do
      let(:naming) { subject.naming_settings }
      it("returns the Name") { expect(naming.name).to eq(organization.name) }
      it("returns the Host") { expect(naming.host).to eq(organization.host) }
      it("returns the Secondary Hosts") { expect(naming.secondary_hosts).to eq(organization.secondary_hosts) }
      it("returns the Reference Prefix") { expect(naming.reference_prefix).to eq(organization.reference_prefix) }
    end

    context ".locale_settings" do
      let(:locales) { subject.locale_settings }
      it("returns the Default Locale") { expect(locales.default_locale).to eq(organization.default_locale) }
      it("returns the Available Locales") { expect(locales.available_locales).to eq(organization.available_locales) }
    end
    context ".smtp_settings" do
      let(:smtp_settings) { subject.smtp_settings }
      context ".from" do
        it "extracts the label and email from the 'from' options" do
          organization.update(smtp_settings: organization.smtp_settings.merge({
            from: "Tony B <b@decidim.com>"
          }));
          expect(smtp_settings.from_label).to eq("Tony B")
          expect(smtp_settings.from_email).to eq("b@decidim.com")
        end
      end
      it "takes the domain from activemailer config" do
        allow(Rails.configuration.action_mailer).to receive(:smtp_settings).and_return({ domain: "test.ch" })
        expect(smtp_settings.domain).to eq("test.ch")
      end
      it "override password from activemailer config" do
        allow(Rails.configuration.action_mailer).to receive(:smtp_settings).and_return({ password: "mypass" })
        organization.update(smtp_settings: {});
        expect(smtp_settings.password).to eq("mypass")
        organization.update(smtp_settings: organization.smtp_settings.merge({
          password: "tesbar"
        }))
        new_smtp_settings = run_rpc(
          :GetSettings,
          empty
        ).smtp_settings
        expect(new_smtp_settings.password).to eq("tesbar")
      end

    end

    context ".color_settings" do
      let(:colors) { subject.color_settings }
      it "fallback to defaults" do
        organization.update!(colors: {});
        expect(colors.alert).to eq("#ec5840")
      end
      it "override colors" do
        organization.update!(colors: { alert: "#eccccc" });
        expect(colors.alert).to eq("#eccccc")
      end
    end

    context ".file_upload_settings" do
      let(:file_upload) { subject.file_upload_settings }
      it "fallback to defaults" do
        organization.update!(file_upload_settings: {})
        expect(file_upload.maximum_file_size_avatar).to eq(5.0)
      end
      it "override values" do
        organization.update!(file_upload_settings: {maximum_file_size: { default: 20 }})
        expect(file_upload.maximum_file_size_default).to eq(20)
      end
    end

    context ".feature_settings" do
      let(:features) { subject.feature_settings }
      context "available_authorizations" do
        it "get default value" do
          expect(features.available_authorizations).to eq([])
        end
        it "get updated value" do
          organization.update!(available_authorizations: ["dummy_authorization_handler"])
          expect(features.available_authorizations).to eq(["dummy_authorization_handler"])
        end
      end
      context "machine_translation_display_priority" do
        it "get default value" do
          expect(features.machine_translation_display_priority).to(
            eq(:SETTINGS_MACHINE_TRANSLATION_PRIORITY_ORIGINAL)
          )
        end
        it "get updated value" do
          expect do
            organization.update!(machine_translation_display_priority: "translated")
          end.to change { run_rpc(
              :GetSettings,
              empty
            ).feature_settings.machine_translation_display_priority }.from(
              :SETTINGS_MACHINE_TRANSLATION_PRIORITY_ORIGINAL
          ).to(
            :SETTINGS_MACHINE_TRANSLATION_PRIORITY_TRANSLATED
          )
        end
      end
      context "enable_machine_translations" do
        it "get default value" do
          expect(features.enable_machine_translations).to eq(false)
        end
        it "get updated value" do
          expect do
            organization.update!(enable_machine_translations: true)
          end.to change { organization.reload.enable_machine_translations }.from(false).to(true)
        end
      end
      context "user_groups_enabled" do
        it "get default value" do
          expect(features.user_groups_enabled).to eq(true)
        end
        it "get updated value" do
          expect do
            organization.update!(user_groups_enabled: false)
          end.to change { organization.reload.user_groups_enabled }.from(true).to(false)
        end
      end
      context "badges_enabled" do
        it "get default value" do
          expect(features.badges_enabled).to eq(true)
        end
        it "get updated value" do
          expect do
            organization.update!(badges_enabled: false)
          end.to change { organization.reload.badges_enabled }.from(true).to(false)
        end
      end
      context "available_authorizations" do
        it "get default value" do
          expect(features.available_authorizations).to eq([])
        end
        it "get updated value" do
          organization.update!(available_authorizations: ["dummy_authorization_handler"])
          expect(features.available_authorizations).to eq(["dummy_authorization_handler"])
        end
      end
    end
  end
end
