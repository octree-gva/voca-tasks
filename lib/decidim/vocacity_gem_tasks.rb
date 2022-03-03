# frozen_string_literal: true

require "decidim/vocacity_gem_tasks/admin"
require "decidim/vocacity_gem_tasks/engine"
require "decidim/vocacity_gem_tasks/admin_engine"
require "decidim/vocacity_gem_tasks/component"

module Decidim
  # This namespace holds the logic of the `VocacityGemTasks` component. This component
  # allows users to create vocacity_gem_tasks in a participatory space.
  module VocacityGemTasks
    class AppBackup
      private
      attr_reader :logger, :date, :db_config, :db_name, :uploads_path, :local_backup_path, :vocacity_bucket

      public
      def initialize
        #@logger = ActiveSupport::Logger.new("log/backup.log")
        #@logger.datetime_format = "%Y-%m-%d %H:%M:%S"
        #@logger.level = Logger::DEBUG

        #@logger.info "Init AppBackup"
        
        time = Time.new
        @date = time.strftime("%Y-%m-%d_%H-%M-%S")
        
        @db_config = ENV['DATABASE_URL']
        @db_name = ENV['DATABASE_URL'].split("/")[-1]
        @uploads_path = ENV['RAILS_ROOT'] + "/public/uploads"
        @uploads_path_name = @uploads_path.split("/")[-1]
        @local_backup_path = ENV['LOCAL_BACKUP_PATH']
        @vocacity_bucket = ENV['VOCACITY_BUCKET']
      end

      private
      def exec_command(command)
        begin
          #@logger.info "Exec Command"

          # IO.popen(command) {|command_io|
          #    command_output = command_io.readlines
          #    @logger.info command_output
          #}
          command_output = system(command)
          if command_output == true
              @logger.info "Command Worked"
          else
              raise "The command has failed"
          end
        rescue Exception => e
          puts e.message
          #@logger.error e.message
        end
      end

      private
      def compress_file(file)
        begin
          compress_command = "gzip #{file}"
          exec_command(compress_command)
        rescue Exception => e
          puts e.message
          #@logger.error e.message
        end
      end

      public
      def run_pg_dump
        begin
          logger.info "Running pg_dump"
          dump_file_name = "#@db_name-#@date.dump"
          pg_dump_command = "pg_dump -Fc -d #{db_config} -f #@local_backup_path/#{dump_file_name}"
          exec_command(pg_dump_command)
          compress_file("#@local_backup_path/#{dump_file_name}")
        rescue Exception => e
          puts e.message
          #@logger.error e.message
        end
      end

      public
      def run_file_system_backup
        begin
          logger.info "Running run_file_system_backup"
          tar_file_name = "#@uploads_path_name-#@date.tgz"
          tar_command = "tar -czf #@local_backup_path/#{tar_file_name} #@uploads_path"
          exec_command(tar_command)
        rescue Exception => e
          puts e.message
          #@logger.error e.message
        end
      end
  end
  end
end
