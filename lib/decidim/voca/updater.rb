# frozen_string_literal: true

module Decidim
  module Voca
    class Updater
      class << self
        def update!(options)
          ActiveSupport::Deprecation.warn('deprecated.')

          updater = self.new(options.deep_symbolize_keys)
        end
      end

      attr_reader :options
      def initialize(options)
        @options = options
        validate_options!
        update!
      end

    private
      def validate_options!
        allowed_attributes = [
          :org_name,
          :org_prefix,
          :host,
          :default_locale,
          :available_locales
        ]
        options.each do |k, v|
          raise Decidim::Voca::Error.new("invalid option #{k}") unless allowed_attributes.include?(k)
        end
      end

      def update!
        Decidim::Organization.first!.update!(transformed_options)
      end

      def transformed_options
        transform = {}
        transform[:host] = options[:host] if options[:host].present?
        transform[:name] = options[:org_name] if options[:org_name].present?
        transform[:default_locale] = options[:default_locale] if options[:default_locale].present?
        transform[:available_locales] = options[:available_locales].split(",").map(&:strip).map(&:to_sym) if options[:available_locales].present?
        transform[:reference_prefix] = options[:org_prefix] if options[:org_prefix].present?
        transform
      end
    end
  end
end
