require "rake"
module Decidim
  module Voca
    module Rpc
      class Seed
        include ::VocaDecidim
        attr_reader :message

        def initialize(message)
          @message = message
        end

        # migrate the database and insert default values.
        # @returns nil
        def seed
          # If an organization is already present, should not seed.
          return if ::Decidim::Organization.count > 0
          seed_system_admin!
          seed_organization!
          seed_admin!
          ::Google::Protobuf::Empty
        end

        private
          def seed_system_admin!
            ::Decidim::System::Admin.create!(
              email: message.system_email,
              password: message.system_password,
              password_confirmation: message.system_password,
            )
          end

          def seed_organization!
            organization = ::Decidim::Organization.create!(
              host: message.host,
              name: message.name,
              default_locale: message.default_locale.to_sym,
              available_locales: message.available_locales.split(",").map(&:to_sym),
              reference_prefix: message.short_name,
              available_authorizations: [],
              users_registration_mode: :enabled,
              tos_version: Time.current,
              badges_enabled: true,
              user_groups_enabled: true,
              send_welcome_notification: true,
              file_upload_settings: ::Decidim::OrganizationSettings.default(:upload)
            )

            ::Decidim::System::CreateDefaultPages.call(organization)
            ::Decidim::System::PopulateHelp.call(organization)
            ::Decidim::System::CreateDefaultContentBlocks.call(organization)
          end
          
          def seed_admin!
            password = ::Devise.friendly_token.first(12)
            organization = ::Decidim::Organization.first
            email = message.admin_email
            matches = email[/[^@]+/].split(".").map { |n| n.gsub(/[^[:alnum:]]/, "") }
            name = matches.map(&:capitalize).join(" ")
            nickname = matches.map(&:downcase).join("_")
            user = ::Decidim::User.create!(
              email: email,
              name: name,
              nickname: nickname,
              password: password,
              password_confirmation: password,
              organization: organization,
              confirmed_at: Time.current,
              locale: organization.default_locale,
              admin: true,
              tos_agreement: true,
              personal_url: "",
              about: "",
              accepted_tos_version: organization.tos_version,
              admin_terms_accepted_at: Time.current
            )
            WebhookNotifierJob.perform_now(
              {
                id: user.id,
                email: user.email,
                name: user.name,
                nickname: user.nickname,
                password: password,
                level: "info"
              },
              "decidim.admin_created"
            )
          rescue Exception => e
            WebhookNotifierJob.perform_now(
              {
                error: "#{e}",
                email: email,
                name: name,
                nickname: nickname,
                password: password,
                level: "error"
              },
              "decidim.admin_created"
            )
          end

      end
    end
  end
end
