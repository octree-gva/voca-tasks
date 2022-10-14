
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
        invoke!("assets:precompile")
        ::Google::Protobuf::Empty
      end

      def seed
        invoke!("db:migrate")
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
        def invoke!(task_name)
          Rake::Task[task_name].invoke
        end
        def message
          request.message
        end

        def organization
          ::Decidim::Organization.first!
        end
    end
  end
end
