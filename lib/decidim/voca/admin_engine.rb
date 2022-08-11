# frozen_string_literal: true

module Decidim
  module Voca
    # This is the engine that runs on the public interface of `Voca`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Voca::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :voca do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "voca#index"
      end

      def load_seed
        nil
      end
    end
  end
end
