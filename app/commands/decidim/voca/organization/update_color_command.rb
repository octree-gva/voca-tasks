module Decidim
  module Voca
    module Organization
      class UpdateColorCommand < UpdateOrganizationCommand
        attr_reader :color_settings
        def initialize(color_settings)
          @color_settings = with_defaults(color_settings.to_h.with_indifferent_access)
        end

        def call
          organization.update!(
            colors: (organization.colors || []).merge(color_settings.delete_if { |_k, v| v.blank? })
            )
          broadcast(:ok)
        rescue e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private
          def with_defaults(colors)
            {
              "alert": "#ec5840",
              "primary": "#cb3c29",
              "success": "#57d685",
              "warning": "#ffae00",
              "highlight": "#be6400",
              "secondary": "#39747f",
              "highlight-alternative": "#be6400"
            }.merge(colors)
          end
      end
    end
  end
end
