# frozen_string_literal: true


Bundler.require(:default, :development)

require "active_support"
require "decidim/dev"
require "tmpdir"
require "vocacity_gem_tasks"

Rails.logger = {}
ENV["WEBHOOK_HMAC"] = "WEBHOOK_HMAC"
ENV["WEBHOOK_URL"] = "http://WEBHOOK_URL"
ENV["INSTANCE_UUID"] = "INSTANCE_UUID"
ENV["DECIDIM_VERSION"] = "DECIDIM_VERSION"
ENV["TZ"] = "TZ"
ENV["DATABASE_HOST"] = "DATABASE_HOST"
ENV["DATABASE_USERNAME"] = "DATABASE_USERNAME"
ENV["DATABASE_PASSWORD"] = "DATABASE_PASSWORD"
ENV["DATABASE_DATABASE"] = "DATABASE_DATABASE"
ENV["RAILS_ROOT"] = "RAILS_ROOT"

Rails.logger = {}
RSpec.configure do |config|
  config.before(:each) do
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:warn)
    allow(Rails.logger).to receive(:error)
    allow(Rails.logger).to receive(:debug)
  end
end
