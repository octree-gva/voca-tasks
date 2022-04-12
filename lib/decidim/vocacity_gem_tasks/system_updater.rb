require "rake"

module Decidim
  module VocacityGemTasks
    class SystemUpdater
      attr_accessor :organization
      def initialize
        @organization = Decidim::Organization.first
      end

      def naming(options)
        options.deep_symbolize_keys!
        to_update = {}
        to_update[:host] = options[:host] unless options[:host].blank?
        to_update[:secondary_hosts] = [options[:secondary_host]] unless options[:secondary_host].blank?
        to_update[:name] = options[:name] unless options[:name].blank?
        to_update[:reference_prefix] = options[:reference_prefix] unless options[:reference_prefix].blank?
        organization.update!(to_update)
      end

      def locales(options)
        options.deep_symbolize_keys!
        raise Error, "Must specify a default locale" if options[:default].blank?
        default_locale = options[:default].to_sym
        options[:available] = [default_locale] if options[:available].blank?
        available_locales = options[:available].map(&:to_sym)
        organization.update!(default_locale: default_locale, available_locales: available_locales)
        sync_locales
      end

      def features(options)
        options.deep_symbolize_keys!
        to_update = {}
        to_update[:users_registration_mode] = options[:registration_mode] unless options[:registration_mode].blank?
        to_update[:badges_enabled] = options[:badges] == "enabled" unless options[:badges].blank?
        to_update[:user_groups_enabled] = options[:user_groups] == "enabled" unless options[:user_groups].blank?
        organization.update!(to_update)
      end

      private

        def sync_locales
          ["decidim:locales:sync_all", "decidim:locales:rebuild_search"].each do |task|
            Rake::Task[task].invoke
          end
        end
    end
  end
end
