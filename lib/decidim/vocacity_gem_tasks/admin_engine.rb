# frozen_string_literal: true

module Decidim
  module VocacityGemTasks
    # This is the engine that runs on the public interface of `VocacityGemTasks`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::VocacityGemTasks::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :vocacity_gem_tasks do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "vocacity_gem_tasks#index"
      end

      def load_seed
        nil
      end
    end
  end
end
