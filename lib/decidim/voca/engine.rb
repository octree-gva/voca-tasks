# frozen_string_literal: true

require "rails"
require "decidim/core"
module Decidim
  module Voca
    # This is the engine that runs on the public interface of voca.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Voca

      routes do
        # Add engine routes here
        # resources :voca
        # root to: "voca#index"
      end

      initializer "decidim_voca.assets" do |app|
        app.config.assets.precompile += %w[decidim_voca_manifest.js decidim_voca_manifest.css]
      end
      initializer "decidim_voca.gruf" do |app|
        ::Gruf.configure do |c|
          c.server_binding_url = ENV.fetch("GRPC_HOST", "0.0.0.0") + ":" + ENV.fetch("GRPC_PORT", "4445")
          c.rpc_server_options = c.rpc_server_options.merge(pool_size: [ENV.fetch("RAILS_MAX_THREADS", 5).to_i - 1, 1].max)
        end
        puts "server started"
      end
    end
  end
end
