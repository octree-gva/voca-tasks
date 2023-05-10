module Decidim
  module Voca
    module Organization
      class UpdateEnvironmentCommand < OrganizationCommand
        attr_reader :config
        def initialize(config)
          @config =  config.to_h.with_indifferent_access
        end

        def call
          redis = Redis.new(url: ENV["REDIS_CONFIG_URL"])
          config.each do |key, value|
            redis.hset("config",key,value)
          end
          broadcast(:ok)
        rescue 
          Rails.logger.error("ERROR")
          broadcast(:fail)
        end
      end
    end
  end
end
