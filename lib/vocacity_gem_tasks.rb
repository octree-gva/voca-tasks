# frozen_string_literal: true

require_relative "vocacity_gem_tasks/app_backup"
require_relative "vocacity_gem_tasks/app_periodical_slave"
require_relative "vocacity_gem_tasks/app_send_to_s3"
require_relative "vocacity_gem_tasks/version"

module VocacityGemTasks
  class Error < StandardError; end
end
