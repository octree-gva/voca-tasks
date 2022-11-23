module Decidim
  module Voca
    module Organization
      class UpdateLocaleCommand < OrganizationCommand
        attr_reader :locale_settings
        def initialize(locale_settings)
          @locale_settings = locale_settings.to_h
        end

        def call
          organization.update!(locale_settings.delete_if { |_k, v| v.blank? })
          after_updating_languages
          broadcast(:ok)
        rescue StandardError => e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private

          def after_updating_languages
            `bundle exec rake decidim:locales:sync_all`
            `bundle exec rake decidim:locales:rebuild_search`
            org = organization.reload
            ::Decidim::User.where.not(locale: org.available_locales).each do |user|
              user.update!(locale: org.default_locale)
            end
          end
      end
    end
  end
end
