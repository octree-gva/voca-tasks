module Decidim
  module Voca
    module Organization
      class UpdateFileUploadCommand < OrganizationCommand
        attr_reader :file_upload_settings
        def initialize(file_upload_settings)
          @file_upload_settings = with_defaults(
            file_upload_settings.to_h.with_indifferent_access
          )
        end

        def call
          organization.update!(
            file_upload_settings: file_upload_settings
          )
          broadcast(:ok)
        rescue e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private
          def with_defaults(settings)
            uploads = ::Decidim::OrganizationSettings.for(
              organization
            ).upload
            uploads.to_h.merge({
              maximum_file_size: uploads.maximum_file_size.to_h.merge({
                avatar: settings[:maximum_file_size_avatar].to_i,
                default: settings[:maximum_file_size_default].to_i,
              }.delete_if { |_k, v| v == 0.0}),
              allowed_content_types: uploads.allowed_content_types.to_h.merge({
                admin: settings[:allowed_content_types_admin],
                default: settings[:allowed_content_types_default],
              }.delete_if { |_k, v| v.blank?}),
              allowed_file_extensions: uploads.allowed_file_extensions.to_h.merge({
                admin: settings[:allowed_file_extensions_admin],
                default: settings[:allowed_file_extensions_default],
              }.delete_if { |_k, v| v.blank?}),
            }.delete_if { |_k, v| v.blank?})
          end
      end
    end
  end
end
