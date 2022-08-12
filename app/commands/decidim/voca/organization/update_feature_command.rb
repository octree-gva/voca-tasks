module Decidim
  module Voca
    module Organization
      class UpdateFeatureCommand < UpdateOrganizationCommand
        attr_reader :feature_settings
        def initialize(feature_settings)
          @feature_settings = with_enums(
            feature_settings.to_h.with_indifferent_access
          )
        end

        def call
          organization.update!(
            feature_settings.delete_if { |_k, v| v.blank? }
          )
          broadcast(:ok)
        rescue e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private
          def with_enums(settings)
            settings["machine_translation_display_priority"] = Decidim::Voca::Rpc::EnumCasting.machine_translation_display_priority.rpc_to_decidim(
              settings["machine_translation_display_priority"]
            )
            settings
          end
      end
    end
  end
end
