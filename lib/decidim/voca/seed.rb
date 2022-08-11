# frozen_string_literal: true

module Decidim
  module Voca
    class Seed
      class << self
        def seed!(options)
          seeder = self.new(options.deep_symbolize_keys)
        end
      end

      attr_reader :options
      def initialize(options)
        @options = options
        validate_options!
        seed_system_admin!
        seed_system_organization!
        seed_admin!
      end

    private
      def validate_options!
        [
          :system_admin_email,
          :system_admin_password,
          :admin_email,
          :org_name,
          :org_prefix,
          :host,
          :default_locale,
          :available_locales
        ].each do |k|
          raise Decidim::Voca::Error.new("missing option #{k}") unless options.key?(k)
          raise Decidim::Voca::Error.new("option #{k} is empty") if options[k].blank?
        end
      end

      def seed_system_admin!
        Decidim::System::Admin.create!(
          email: options[:system_admin_email],
          password: options[:system_admin_password],
          password_confirmation: options[:system_admin_password]
        )
      end

      def seed_admin!
        password = Devise.friendly_token.first(12)
        organization = Decidim::Organization.first
        email = options[:admin_email]
        matches = email[/[^@]+/].split(".").map { |n| n.gsub(/[^[:alnum:]]/, "") }
        name = matches.map(&:capitalize).join(" ")
        nickname = matches.map(&:downcase).join("_")
        begin
        user = Decidim::User.create!(
          email: email,
          name: name,
          nickname: nickname,
          password: password,
          password_confirmation: password,
          organization: organization,
          confirmed_at: Time.current,
          locale: I18n.default_locale,
          admin: true,
          tos_agreement: true,
          personal_url: "",
          about: "",
          accepted_tos_version: organization.tos_version,
          admin_terms_accepted_at: Time.current
        )
        WebhookNotifierJob.perform_now(
          {
            id: user.id,
            email: user.email,
            name: user.name,
            nickname: user.nickname,
            password: password,
            level: "info"
          },
          "decidim.admin_created"
        )
      rescue Exception => e
        WebhookNotifierJob.perform_now(
          {
            error: "#{e}",
            email: email,
            name: name,
            nickname: nickname,
            password: password,
            level: "error"
          },
          "decidim.admin_created"
        )
      end
      end

      def seed_system_organization!
        organization = Decidim::Organization.create!(
          host: options[:host],
          name: options[:org_name],
          default_locale: options[:default_locale],
          available_locales: options[:available_locales].split(",").map(&:to_sym),
          reference_prefix: options[:org_prefix],
          available_authorizations: [],
          users_registration_mode: :enabled,
          tos_version: Time.current,
          badges_enabled: true,
          user_groups_enabled: true,
          send_welcome_notification: true,
          file_upload_settings: Decidim::OrganizationSettings.default(:upload)
        )

        Decidim::System::CreateDefaultPages.call(organization)
        Decidim::System::PopulateHelp.call(organization)
        Decidim::System::CreateDefaultContentBlocks.call(organization)
      end
    end
  end
end
