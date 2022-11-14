
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
        `bundle exec rails assets:precompile`
        ::Google::Protobuf::Empty.new
      end
      
      def setup_db
        `bundle exec rails db:migrate`
        ::Decidim::Voca::Rpc::SetupDb.new.seed
        ::Google::Protobuf::Empty.new
      end

      def seed_admin
        seeder = ::Decidim::Voca::Rpc::SeedAdmin.new(message)
        seeder.seed
        ::VocaDecidim::SeedAdminResponse.new(
          admin_email: message.admin_email,
          admin_password: seeder.password
        )
      rescue ActiveRecord::RecordNotFound => _e
        fail!(:not_found, :organization_not_found, "No organization is ready, have you seeded?")
      end


      def set_settings
        ::Decidim::Voca::Rpc::SetSettings.new(
          message,
          organization
        ).set_settings
        ::Google::Protobuf::Empty.new
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
