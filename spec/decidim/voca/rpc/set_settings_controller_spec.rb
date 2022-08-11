require "spec_helper"

describe Decidim::Voca::SetSettingsController do
  let(:empty) { ::Google::Protobuf::Empty.new }
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

  def set_settings(arguments)
    run_rpc(
      :SetSettings,
      ::VocaDecidim::SetSettingsRequest.new(arguments)
    )
  end

  context "#set_settings" do
    context ".naming_settings" do
      it "updates name" do
        name_settings = ::VocaDecidim::DecidimOrganizationNamingSettings.new(name: "test")
        expect do
          set_settings(
            naming_settings: name_settings
          )
        end.to change { organization.reload.name }.to("test")
      end
    end
    context ".locale_settings" do
      it ".default_locale" do
        organization.update(available_locales: ["ca", "es"], default_locale: "es")
        locale_settings = ::VocaDecidim::DecidimOrganizationLocaleSettings.new(default_locale: "ca")
        expect do
          set_settings(
            locale_settings: locale_settings
          )
        end.to change { organization.reload.default_locale }.from("es").to("ca")
      end
      it ".available_locales" do
        locale_settings = ::VocaDecidim::DecidimOrganizationLocaleSettings.new(available_locales: ["es", "ca"])
        expect do
          set_settings(
            locale_settings: locale_settings
          )
        end.to change { organization.reload.available_locales }.to(["es", "ca"])
      end
    end
    context ".permission_settings" do
      it ".force_users_to_authenticate_before_access_organization" do
        permission_settings = ::VocaDecidim::DecidimOrganizationPermissionSettings.new(
          force_users_to_authenticate_before_access_organization: true
        )
        expect do
          set_settings(
            permission_settings: permission_settings
          )
        end.to change {
          organization.reload.force_users_to_authenticate_before_access_organization
        }.to(true)
      end
      it ".users_registration_mode" do
        permission_settings = ::VocaDecidim::DecidimOrganizationPermissionSettings.new(
          users_registration_mode: :SETTINGS_REGISTER_MODE_EXTERNAL
        )
        expect do
          set_settings(
            permission_settings: permission_settings
          )
        end.to change {
          organization.reload.users_registration_mode
        }.to("disabled")
      end
    end
    context ".smtp_settings" do
      context "smtp_settings is empty" do
        before(:each) { organization.update(smtp_settings: {}) }

        it ".from_label without from_email gives JohnDoe <example@decidim.org>" do
          smtp_settings = ::VocaDecidim::DecidimOrganizationSMTPSettings.new(
            from_label: "JohnDoe"
          )
          expect do
            set_settings(
              smtp_settings: smtp_settings
            )
          end.to change {
            organization.reload.smtp_settings["from"]
          }.to("JohnDoe <example@decidim.org>")
        end
      end
      context "smtp_settings is defined" do
        before(:each) { organization.update(smtp_settings: {
          user_name: "test",
          password: "sk_123",
          port: 1552,
          address: "mail.infomaniak.ch",
          from: "test <test@decidim.org>",
        }) }

        it ".from_label without from_email leaves from_email intact" do
          smtp_settings = ::VocaDecidim::DecidimOrganizationSMTPSettings.new(
            from_label: "JohnDoe"
          )
          expect do
            set_settings(
              smtp_settings: smtp_settings
            )
          end.to change {
            organization.reload.smtp_settings["from"]
          }.to("JohnDoe <test@decidim.org>")
        end
      end
    end

    context ".color_settings" do
      it "updates alert" do
        color_settings = ::VocaDecidim::DecidimOrganizationColorSettings.new(alert: "#400555")
        expect do
          set_settings(
            color_settings: color_settings
          )
        end.to change { organization.reload.colors["alert"] }.to("#400555")
      end
    end
    context ".file_upload_settings" do
      it "updates max file uploads" do
        file_upload_settings = ::VocaDecidim::DecidimOrganizationFileUploadSettings.new(
          maximum_file_size_default: 30
        )
        expect do
          set_settings(
            file_upload_settings: file_upload_settings
          )
        end.to change {
          organization.reload.file_upload_settings["maximum_file_size"]["default"]
        }.to(30)
      end
    end
    context ".feature_settings" do
      it "change machine translation display priority" do
        feature_settings = ::VocaDecidim::DecidimOrganizationFeatureFlagSettings.new(
          machine_translation_display_priority: :SETTINGS_MACHINE_TRANSLATION_PRIORITY_TRANSLATED
        )
        expect do
          set_settings(
            feature_settings: feature_settings
          )
        end.to change {
          organization.reload.machine_translation_display_priority
        }.to("translated")
      end
    end
  end
end
