module Decidim
  module Voca
    class DynamicConfigMiddleware
      # Initializes the middleware with a Redis client and a Redis key name
      #
      # @param app [Object] Rack application to call
      # @param redis_client [Redis] Redis client instance
      # @param redis_key [String] Redis key name to retrieve configuration data from
      def initialize(app, redis_client, redis_key)
        @app = app
        @redis_client = redis_client
        @redis_key = redis_key
      end

      # Calls the Rack application and sets configuration data from Redis key
      #
      # @param env [Hash] Rack environment variables
      # @return [Array] Rack response array
      def call(env)
        configure_decidim_with_redis_data
        # Call Rack application
        @app.call(env)
      end

      private

      def configure_decidim_with_redis_data
        config_data = @redis_client.hgetall(@redis_key)
        return unless config_data.present?
      
        # Set configuration attributes using config_data
        if config_data["currency_unit"].present?
          Decidim.currency_unit = config_data["currency_unit"]
        end
        if config_data["timezone"].present?
          ENV["TZ"] = config_data["timezone"] || ENV.fetch("TZ", "UTC")
          Rails.application.config.time_zone = ActiveSupport::TimeZone[ENV["TZ"]] 
        end
      end
    end
  end
end