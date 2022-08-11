

module Decidim
  module Voca
    class SetSettingsController < ::Gruf::Controllers::Base
      include ::VocaDecidim
      bind ::VocaDecidim::Decidim::Service

      # add_message "voca_decidim.SetSettingsRequest" do
      #   proto3_optional :permission_settings, :message, 1, "voca_decidim.DecidimOrganizationPermissionSettings"
      #   proto3_optional :naming_settings, :message, 2, "voca_decidim.DecidimOrganizationNamingSettings"
      #   proto3_optional :locale_settings, :message, 3, "voca_decidim.DecidimOrganizationLocaleSettings"
      #   proto3_optional :smtp_settings, :message, 4, "voca_decidim.DecidimOrganizationSMTPSettings"
      #   proto3_optional :color_settings, :message, 5, "voca_decidim.DecidimOrganizationColorSettings"
      #   proto3_optional :file_upload_settings, :message, 6, "voca_decidim.DecidimOrganizationFileUploadSettings"
      #   proto3_optional :feature_settings, :message, 7, "voca_decidim.DecidimOrganizationFeatureFlagSettings"
      # end
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

      def organization
        @organization ||= ::Decidim::Organization.first!
      end
      def message
        request.message
      end
    end
  end
end
