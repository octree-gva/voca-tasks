# frozen_string_literal: true

module Decidim
    # Main application mailer configuration. Inherit from this to create new
    # mailers.
    class ApplicationMailer < ActionMailer::Base
      include LocalisedMailer
      include MultitenantAssetHost
      after_action :set_smtp
  
      default from: Decidim.config.mailer_sender
      layout "decidim/mailer"
  
      private
  
      def set_smtp
        return if @organization.nil? || @organization.smtp_settings.blank?
  
        mail.from = @organization.smtp_settings["from"].presence || mail.from
        mail.reply_to = mail.reply_to || Decidim.config.mailer_reply

        port = "#{@organization.smtp_settings["port"] || "587"}".to_i
        is_tls = mail.delivery_method.settings["tls"]
        mail.delivery_method.settings.merge!(
          address: @organization.smtp_settings["address"],
          port: @organization.smtp_settings["port"],
          user_name: @organization.smtp_settings["user_name"],
          password: Decidim::AttributeEncryptor.decrypt(@organization.smtp_settings["encrypted_password"]),
          ssl: port == 465,
          enable_starttls_auto: !is_tls && port == 587
        )  { |_k, o, v| v.presence || o }.reject! { |_k, v| v.blank? }
      end
    end
  end