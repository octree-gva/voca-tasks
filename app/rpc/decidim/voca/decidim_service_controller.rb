
require "rake"
module Decidim
  module Voca
    class DecidimServiceController < ::Gruf::Controllers::Base
      include ::VocaDecidim
      bind ::VocaDecidim::Decidim::Service

      def get_settings
        ::Decidim::Voca::Rpc::GetSettings.new(
          message,
          organization
        ).get_settings
      rescue ActiveRecord::RecordNotFound => _e
        fail!(:not_found, :organization_not_found, "No organization is ready, have you seeded?")
      end

      def compile_assets
        Rake::Task["assets:precompile"].invoke
        nil
      end

      def seed
        ::Decidim::Voca::Rpc::Seed.new(
          message
        ).seed
      end

      def set_settings
        ::Decidim::Voca::Rpc::SetSettings.new(
          message,
          organization
        ).set_settings
      rescue ActiveRecord::RecordNotFound => _e
        fail!(:not_found, :organization_not_found, "No organization is ready, have you seeded?")
      end

      private

        def message
          request.message
        end

        def organization
          ::Decidim::Organization.first!
        end
    end
  end
end
