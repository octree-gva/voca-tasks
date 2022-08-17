require "i18n/tasks"

module Decidim
  module Voca
    module Organization
      class CheckCommand < OrganizationCommand
        def call
          # Check migration status
          migrations = migration_status
          # Check i18n keys
          i18n = i18n_status
          # Check permissions on public folder
          # Check permissions on log folder
          # Check organization validation,

        rescue e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private

          def i18n_status
            i18n = I18n::Tasks::BaseTask.new({ locales: organization.available_locales })
            Hash[organization.available_locales.map do |locale|
              missing_keys = i18n.missing_keys.get(locale.to_sym)
              if missing_keys.nil?
                [locale, []]
              else
                [locale, missing_keys.children.key_names]
              end
            end]
          end

          def migration_status
            regexp = /^[ ]*(up|down)[ ]*([0-9]*).*/
            Hash[`bundle exec rails db:migrate:status`.split("\n").map do |line|
              matches = regexp.match(line)
              raise "migration #{match[2]} down" unless match[1] == "up"
              [match[2], match[1]]
            end]
          end
      end
    end
  end
end
