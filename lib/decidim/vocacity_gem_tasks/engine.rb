# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module VocacityGemTasks
    # This is the engine that runs on the public interface of vocacity_gem_tasks.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::VocacityGemTasks

      routes do
        # Add engine routes here
        # resources :vocacity_gem_tasks
        # root to: "vocacity_gem_tasks#index"
      end

      initializer "decidim_vocacity_gem_tasks.assets" do |app|
        app.config.assets.precompile += %w[decidim_vocacity_gem_tasks_manifest.js decidim_vocacity_gem_tasks_manifest.css]
      end
    end
  end
end