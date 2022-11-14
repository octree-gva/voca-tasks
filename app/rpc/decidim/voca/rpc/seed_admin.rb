require "rake"
module Decidim
  module Voca
    module Rpc
      class SeedAdmin
        include ::VocaDecidim
        attr_reader :message, :organization, :password

        def initialize(message)
          @message = message
          @organization = ::Decidim::Organization.first!
          @password = ::Devise.friendly_token.first(23)
        end

        # migrate the database and insert default values.
        # @returns nil
        def seed
          seed_system_admin!
          seed_admin!
        end

        private
          def seed_system_admin!
            ::Decidim::System::Admin.create!(
              email: message.system_email,
              password: message.system_password,
              password_confirmation: message.system_password,
            )
          end

          def seed_admin!
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
