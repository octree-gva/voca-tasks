module Decidim
  module Voca
    module Organization
      class UpdateSmtpCommand < OrganizationCommand
        attr_reader :smtp_settings
        def initialize(smtp_settings)
          @smtp_settings = transform_settings(smtp_settings.to_h.with_indifferent_access)
        end

        def call
          organization.update!(
            smtp_settings: smtp_settings.delete_if { |_k, v| v.blank? }
          )
          broadcast(:ok)
        rescue => e
          Rails.logger.error(e)
          broadcast(:fail)
        end

        private

          def transform_settings(settings)
            from_label = settings.delete("from_label")
            from_email = settings.delete("from_email")
            username = settings.delete("username")
            password = settings.delete("password")
            settings["openssl_verify_mode"] = Decidim::Voca::Rpc::EnumCasting.smtp_openssl_verify_mode.rpc_to_decidim(
              settings["openssl_verify_mode"]
            )
            settings["authentication"] = Decidim::Voca::Rpc::EnumCasting.smtp_authentication.rpc_to_decidim(
              settings["authentication"]
            )
            settings["user_name"] = username unless username.blank?
            settings["encrypted_password"] = Decidim::AttributeEncryptor.encrypt(password) unless password.blank?
            if from_email.blank? && !from_label.blank?
              active_mailer_config = Rails.configuration.action_mailer.smtp_settings || {}
              current = organization.smtp_settings || {}
              mail = Mail::Address.new(
                current.fetch("from", active_mailer_config.fetch(:from, "example@decidim.org"))
              )
              mail.display_name = from_label
              settings[:from] = mail.to_s
            elsif !from_email.blank?
              mail = Mail::Address.new(from_email)
              mail.display_name = from_label unless from_label.nil?
              settings[:from] = mail.to_s
            end
            settings
          end
      end
    end
  end
end
