require "rake"
module Decidim
  module Voca
    module Rpc
      class SetupDb
        include ::VocaDecidim

        # migrate the database and insert default values.
        # @returns nil
        def seed
          # If an organization is already present, should not seed.
          return if ::Decidim::Organization.count > 0
          seed_organization!
        end

        private

          def seed_organization!
            organization = ::Decidim::Organization.create!(
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

            ::Decidim::System::CreateDefaultPages.call(organization)
            ::Decidim::System::PopulateHelp.call(organization)
            ::Decidim::System::CreateDefaultContentBlocks.call(organization)
          end
          
      end
    end
  end
end
