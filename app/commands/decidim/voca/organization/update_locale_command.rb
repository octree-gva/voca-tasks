module Decidim
  module Voca
    module Organization
      class UpdateLocaleCommand < OrganizationCommand
        attr_reader :locale_settings
        def initialize(locale_settings)
          @locale_settings = locale_settings.to_h
        end

        def call
          # update languages
          organization_configuration = locale_settings.select do |key| 
            "#{key}" == "available_locales" || "#{key}" == "default_locale"
          end.delete_if { |_k, v| v.blank? }
          organization.update!(organization_configuration)
          after_updating_languages
          # update localization settings (currency, timezone)
          global_configuration = locale_settings.select do |key| 
            "#{key}" == "currency_unit" || "#{key}" == "timezone"
          end.delete_if { |_k, v| v.blank? }
          unless global_configuration.empty?
            redis_client = Redis.new(
              url: ENV.fetch("REDIS_CONFIG_URL", "redis://127.0.0.1:6379/2"),
            );
            global_configuration.each do |key, value|
              # Update the Redis hash values
              redis_client.hset("config", "#{key}", "#{value}")
            end
            # Close the Redis connection
            redis_client.quit  
          end
          broadcast(:ok)
        rescue StandardError => e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private
          def after_updating_languages
            # Rebuild locales
            system("bundle exec rails decidim:locales:sync_all")
            # Rebuild search tree
            system("bundle exec rails decidim:locales:rebuild_search")
            org = organization.reload
            # Update user locales (they might not have a locale that is now supported)
            ::Decidim::User.where.not(locale: org.available_locales).each do |user|
              user.update(locale: org.default_locale)
            end
          end
      end
    end
  end
end
