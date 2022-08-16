module Decidim
  module Voca
    module Organization
      class UpdatePermissionCommand < OrganizationCommand
        attr_reader :permission_settings
        def initialize(permission_settings)
          @permission_settings = cast_permission_settings(permission_settings.to_h)
        end

        def call
          organization.update!(permission_settings.delete_if { |_k, v| v.blank? })
          broadcast(:ok)
        rescue e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private

          def cast_permission_settings(permission_settings)
            # Convert enums
            casting = ::Decidim::Voca::Rpc::EnumCasting.users_registration_mode
            permission_settings[:users_registration_mode] = casting.rpc_to_decidim(
              permission_settings[:users_registration_mode]
            )
            permission_settings
          end
      end
    end
  end
end
