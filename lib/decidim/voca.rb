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
require_relative "voca/updater"
require_relative "voca/rpc/decidim_services_pb"
require_relative "voca/middleware/dynamic_config_middleware"

require "active_support/core_ext"
module Decidim
  module Voca
    class Error < StandardError; end
    class << self
      attr_accessor :config
    end
  
    def self.configure
      self.config ||= Configuration.new
      yield(configuration)
    end

    def self.configuration
      self.config ||= Configuration.new
    end
    
    class Configuration
      attr_reader :listeners
  
      def initialize
        @listeners = OpenStruct.new
      end
      
      ##
      # Register a new code block for an event.
      # Decidim::Voca.configure do |conf|
      #   conf.on(:before_seed_db) do || 
      def on(event, &block)
        @listeners[event] ||= []
        @listeners[event] << block
      end

      def trigger(event)
        return unless @listeners[event]
        @listeners[event].map {|bl| bl.call }
      end
    end
  end
end
