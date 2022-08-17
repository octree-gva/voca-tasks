

module Decidim
  module Voca
    module Rpc
      class GetSettings
        include ::VocaDecidim
        attr_reader :message, :organization
        def initialize(message, organization)
          @message = message
          @organization = organization
        end

        # get all the settings linked to the organization.
        # @returns GetSettingsResponse
        def get_settings
          GetSettingsResponse.new(
            id: organization.id,
            permission_settings: permission_settings,
            naming_settings: naming_settings,
            locale_settings: locale_settings,
            smtp_settings: smtp_settings,
            color_settings: color_settings,
            file_upload_settings: file_upload_settings,
            feature_settings: feature_settings
          )
        end

        private
          def feature_settings
            DecidimOrganizationFeatureFlagSettings.new(
              available_authorizations: organization.available_authorizations,
              badges_enabled: organization.badges_enabled,
              user_groups_enabled: organization.user_groups_enabled,
              enable_machine_translations: organization.enable_machine_translations,
              machine_translation_display_priority: EnumCasting.machine_translation_display_priority.decidim_to_rpc(
                organization.machine_translation_display_priority || "original"
              )
            )
          end

          def file_upload_settings
            upload_settings = ::Decidim::OrganizationSettings.for(organization).upload
            DecidimOrganizationFileUploadSettings.new(
              maximum_file_size_avatar: upload_settings.maximum_file_size.avatar,
              maximum_file_size_default: upload_settings.maximum_file_size.default,
              allowed_content_types_admin: upload_settings.allowed_content_types.admin,
              allowed_content_types_default: upload_settings.allowed_content_types.default,
              allowed_file_extensions_admin: upload_settings.allowed_file_extensions.admin,
              allowed_file_extensions_default: upload_settings.allowed_file_extensions.default
            )
          end

          def color_settings
            default_colors = {
              "alert": "#ec5840",
              "primary": "#cb3c29",
              "success": "#57d685",
              "warning": "#ffae00",
              "highlight": "#be6400",
              "secondary": "#39747f",
              "highlight-alternative": "#be6400"
            }
            settings = default_colors.merge((organization.colors || {}).deep_symbolize_keys) { |_k, o, v| v.presence || o }.delete_if { |_k, v| v.blank? }
            DecidimOrganizationColorSettings.new(
              alert: settings[:alert],
              primary: settings[:primary],
              success: settings[:success],
              warning: settings[:warning],
              highlight: settings[:highlight],
              secondary: settings[:secondary],
              highlight_alternative: settings["highlight-alternative".to_sym]
            )
          end

          def smtp_settings
            active_mailer_config = Rails.configuration.action_mailer.smtp_settings || {}
            tenant_config = organization.smtp_settings || {}
            from = tenant_config.fetch("from", active_mailer_config.fetch(:from, ""))

            email = Mail::Address.new(from)
            current_settings = active_mailer_config.merge({
              password: tenant_config["password"],
              user_name: tenant_config["user_name"],
              port: tenant_config["port"],
              address: tenant_config["address"],
              from_label: email.present? ? email.display_name : nil,
              from_email:  email.present? ? email.address : nil
            }) { |_k, o, v| v.presence || o }.delete_if { |_k, v| v.blank? }

            DecidimOrganizationSMTPSettings.new(
              from_label: current_settings[:from_label],
              from_email: current_settings[:from_email],
              address: current_settings[:address],
              port: current_settings[:port],
              authentication: current_settings[:authentication],
              username: current_settings[:user_name],
              password: current_settings[:password],
              domain: current_settings[:domain],
              enable_starttls_auto: current_settings[:enable_starttls_auto],
              openssl_verify_mode: current_settings[:openssl_verify_mode]
            )
          end

          def permission_settings
            DecidimOrganizationPermissionSettings.new(
              force_users_to_authenticate_before_access_organization:
                organization.force_users_to_authenticate_before_access_organization,
              users_registration_mode: EnumCasting.users_registration_mode.decidim_to_rpc(
                organization.users_registration_mode
              )
            )
          end


          def locale_settings
            DecidimOrganizationLocaleSettings.new(
              default_locale: organization.default_locale,
              available_locales: organization.available_locales
            )
          end

          def naming_settings
            DecidimOrganizationNamingSettings.new(
              host: organization.host,
              secondary_hosts: organization.secondary_hosts,
              name: organization.name,
              reference_prefix: organization.reference_prefix
            )
          end
      end
    end
  end
end
