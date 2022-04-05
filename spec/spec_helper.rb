# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require "decidim/dev"
require "database_cleaner/active_record"

DatabaseCleaner.strategy = :truncation

require "simplecov"
SimpleCov.start "rails"
if ENV["CODECOV"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path =
  File.expand_path(File.join(__dir__, "dummy"))

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|

  config.before do
    ENV["WEBHOOK_HMAC"] = "webhook_hmac"
    ENV["WEBHOOK_URL"] = "http://webhook_url"
    ENV["INSTANCE_UUID"] = "instance_uuid"
    ENV["RAILS_ROOT"] = "root"
    ENV["DECIDIM_DEFAULT_SYSTEM_EMAIL"] = "decidim_default_system@email.com"
    ENV["DECIDIM_DEFAULT_SYSTEM_PASSWORD"] = "decidim_default_system_password"
    # Reset the locales to Decidim defaults before each test.
    # Some tests may change this which is why this is important.
    I18n.available_locales = [:en, :ca, :es]

    # Revert back to the simple backend before every test because otherwise the
    # tests may be interfered by the backend set by the specific tests. You
    # could otherwise see the following errors in case the tests are not run in
    # a specific order (where the test setting the custom backend would be
    # last):
    #   #<Double (anonymous)> was originally created in one example but has
    #   leaked into another example and can no longer be used
    #
    # The reason for this is that the factories are calling the faker gem which
    # is calling the translate method using the currently active I18n backend.
    I18n.backend = I18n::Backend::Simple.new

    # Remove the subscribers from the start_processing.action_controller
    # notification so that it does not leave any subscribers from individual
    # tests which might be using the test doubles. May cause the same error as
    # explained above.
    ActiveSupport::Notifications.unsubscribe(
      "start_processing.action_controller"
    )
  end
end
