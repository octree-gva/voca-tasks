module Decidim
  module Voca
    module Organization
      class UpdateLocaleCommand < UpdateOrganizationCommand
        attr_reader :locale_settings
        def initialize(locale_settings)
          @locale_settings = locale_settings.to_h
        end

        def call
          organization.update!(locale_settings.delete_if { |_k, v| v.blank? })
          broadcast(:ok)
        rescue StandardError => e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private

          def after_updating_languages
            # TODO run re-indexing if needed.
            # TODO enqueue a check on i18ntasks to report any issues
          end
      end
    end
  end
end