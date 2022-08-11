module Decidim
  module Voca
    module Organization
      class UpdateNamingCommand < UpdateOrganizationCommand
        attr_reader :naming_settings
        def initialize(naming_settings)
          @naming_settings = naming_settings.to_h
        end

        def call
          organization.update!(naming_settings.delete_if { |_k, v| v.blank? })
          broadcast(:ok)
        rescue e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private

          def update_host
            # Todo call Voca system to update the redirection
          end

          def update_subdomain
            # Todo call Voca system to update aliases
          end
      end
    end
  end
end