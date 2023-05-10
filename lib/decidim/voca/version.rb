# frozen_string_literal: true

# This holds the decidim-meetings version.
module Decidim
  module Voca
    def self.version
      ENV.fetch("DECIDIM_VERSION", "0.26.4")
    end
  end
end
