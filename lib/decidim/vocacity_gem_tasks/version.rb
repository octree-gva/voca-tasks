# frozen_string_literal: true

module Decidim
  # This holds the decidim-meetings version.
  module VocacityGemTasks
    def self.version
      ENV.fetch("DECIDIM_VERSION", "0.24.3")
    end
  end
end
