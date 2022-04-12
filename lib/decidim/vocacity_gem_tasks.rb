# frozen_string_literal: true

require_relative "vocacity_gem_tasks/admin"
require_relative "vocacity_gem_tasks/engine"
require_relative "vocacity_gem_tasks/admin_engine"
require_relative "vocacity_gem_tasks/version"

require_relative "vocacity_gem_tasks/backup/app_backup"
require_relative "vocacity_gem_tasks/backup/app_upload_to_s3"
require_relative "vocacity_gem_tasks/seed"
require_relative "vocacity_gem_tasks/system_updater"

require "active_support/core_ext"
require "rails"

module Decidim
  module VocacityGemTasks
    class Error < StandardError; end
  end
end
