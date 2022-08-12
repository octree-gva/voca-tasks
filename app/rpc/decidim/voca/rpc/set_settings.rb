
module Decidim
  module Voca
    module Rpc
      class SetSettings
        include ::VocaDecidim
        attr_reader :message, :organization
        def initialize(message, organization)
          @message = message
          @organization = organization
        end
        def set_settings
          response = []
          response << [
            "naming_settings",
            ::Decidim::Voca::Organization::UpdateNamingCommand.call(message.naming_settings)
          ] unless message.naming_settings.nil?
          response << [
            "permission_settings",
            ::Decidim::Voca::Organization::UpdatePermissionCommand.call(message.permission_settings)
          ] unless message.permission_settings.nil?
          response << [
            "locale_settings",
            ::Decidim::Voca::Organization::UpdateLocaleCommand.call(message.locale_settings)
          ] unless message.locale_settings.nil?
          response << [
            "smtp_settings",
            ::Decidim::Voca::Organization::UpdateSmtpCommand.call(message.smtp_settings)
          ] unless message.smtp_settings.nil?
          response << [
            "color_settings",
            ::Decidim::Voca::Organization::UpdateColorCommand.call(message.color_settings)
          ] unless message.color_settings.nil?
          response << [
            "file_upload_settings",
            ::Decidim::Voca::Organization::UpdateFileUploadCommand.call(message.file_upload_settings)
          ] unless message.file_upload_settings.nil?
          response << [
            "feature_settings",
            ::Decidim::Voca::Organization::UpdateFeatureCommand.call(message.feature_settings)
          ] unless message.feature_settings.nil?

          error_string = response.delete_if { |k, v| v.key? :ok }.map(&:first).join(", ")
          unless error_string.empty?
            fail!(:internal, :organization, "Following keys failed :#{error_string}")
          end
        end
      end
    end
  end
end
