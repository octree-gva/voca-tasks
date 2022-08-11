# frozen_string_literal: true

require "gruf"
require_relative "voca/admin"
require_relative "voca/engine"
require_relative "voca/admin_engine"
require_relative "voca/version"

require_relative "voca/backup/app_backup"
require_relative "voca/backup/app_upload_to_s3"
require_relative "voca/backup/app_encrypt_backup_file"
require_relative "voca/backup/app_decrypt_backup_file"
require_relative "voca/seed"
require_relative "voca/updater"
require_relative "voca/rpc/decidim_services_pb"

require "active_support/core_ext"
module Decidim
  module Voca
    class Error < StandardError; end
  end
end
