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
            return if ::Decidim::System::Admin.count > 0
            ::Decidim::System::Admin.create!(
              email: message.system_email,
              password: message.system_password,
              password_confirmation: message.system_password,
            )
          end

          def seed_admin!
            return update_password! if ::Decidim::User.where(admin: true).count > 0
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
          end

          def update_password!
            user = ::Decidim::User.where(admin: true).first!
            email = message.admin_email
            matches = email[/[^@]+/].split(".").map { |n| n.gsub(/[^[:alnum:]]/, "") }
            name = matches.map(&:capitalize).join(" ")
            nickname = matches.map(&:downcase).join("_")
            user.update!(
              email: email,
              name: name,
              nickname: nickname,
              password: password,
              password_confirmation: password,
            )
          end

      end
    end
  end
end
