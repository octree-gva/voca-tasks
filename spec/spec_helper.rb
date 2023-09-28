# frozen_string_literal: true

ENV['RPC_SPEC_PATH'] = '/spec/decidim/voca/rpc'
ENV["RAILS_ENV"] = "test"
ENV["ENGINE_ROOT"] = File.dirname(__dir__)
require "decidim/dev"
require "decidim/core/test"
require "database_cleaner/active_record"
require 'gruf/rspec'
require 'mock_redis'

DatabaseCleaner.strategy = :truncation
  
require "simplecov"
SimpleCov.start "rails"
if ENV["CODECOV"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV["WEBHOOK_HMAC"] = "webhook_hmac"
ENV["WEBHOOK_URL"] = "http://webhook_url"
ENV["INSTANCE_UUID"] = "instance_uuid"
ENV["RAILS_ROOT"] = "root"
ENV["DECIDIM_DEFAULT_SYSTEM_EMAIL"] = "decidim_default_system@email.com"
ENV["DECIDIM_DEFAULT_SYSTEM_PASSWORD"] = "decidim_default_system_password"

Decidim::Dev.dummy_app_path =
  File.expand_path(File.join("spec", "dummy"))
require "decidim/dev/test/base_spec_helper"


RSpec.configure do |config|
  config.before(:each) do
    mock_redis = MockRedis.new
    allow(Redis).to receive(:new).and_return(mock_redis)
  end
end

