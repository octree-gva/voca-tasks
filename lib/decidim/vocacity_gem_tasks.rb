# frozen_string_literal: true

require "decidim/vocacity_gem_tasks/admin"
require "decidim/vocacity_gem_tasks/engine"
require "decidim/vocacity_gem_tasks/admin_engine"
require "decidim/vocacity_gem_tasks/component"

require "rails"

module Decidim
  # This namespace holds the logic of the `VocacityGemTasks` component. This component
  # allows users to create vocacity_gem_tasks in a participatory space.
  module VocacityGemTasks
    class AppBackup
      private
      attr_reader :logger, :date, :db_host, :db_user, :db_pass, :db_name, :uploads_path, :uploads_path_name, :tmp_backup, :vocacity_bucket

      public
      def initialize

        # workaround for init logger
        Rails.logger = Logger.new("log/development.log")

        @logger = Rails.logger
        
        @logger.info "Init AppBackup"
        
        time = Time.new
        @date = time.strftime("%Y-%m-%d_%H-%M-%S")
        
        @db_host = ENV.fetch("DATABASE_HOST")
        @db_user = ENV.fetch("DATABASE_USERNAME")
        @db_pass = ENV.fetch("DATABASE_PASSWORD")
        @db_name = ENV.fetch('DATABASE_DATABASE')
        @db_url = "postgres://#@db_user:#@db_pass@#@db_host:5432/#@db_name"
        @uploads_path = ENV.fetch('RAILS_ROOT') + "/public/uploads"
        @uploads_path_name = @uploads_path.split("/")[-1]
        @tmp_backup = ENV.fetch('RAILS_ROOT') + "/decidim-module-vocacity_gem_tasks/tmp_backup"
        # @vocacity_bucket = ENV.fetch('VOCACITY_BUCKET')
        check_pgpass
      end

      private
      def check_pgpass
        # Check /root/.pgpass exists if not create it
        File.open("/root/.pgpass", "w") { |f| 
          f.write("#@db_host:*:#@db_name:#@db_user:#@db_pass")
          f.chmod(0600)
        } unless File.exists?("/root/.pgpass")
      end

      private
      def exec_command(command)
        begin
          @logger.info "Exec Command"

          command_output = system(command)
          if command_output == true
            @logger.info "The command: #{command} has worked"
          else
              raise "The command: #{command} has failed"
          end
        rescue Exception => e
          @logger.error e.message
        end
      end

      private
      def compress_file(file)
        begin
          if File.exists?(file)
            compress_command = "gzip #{file}"
            exec_command(compress_command)
          else
            raise "File #{file} doesn't exists"
          end
        rescue Exception => e
          @logger.error e.message
        end
      end

      public
      def run_pg_dump
        begin
          @logger.info "Running pg_dump"
          Dir.mkdir(@tmp_backup) unless Dir.exists?(@tmp_backup)
          if Dir.exists?(@tmp_backup)
            dump_file_name = "#@db_name-#@date.dump"
            pg_dump_command = "pg_dump -v -Fc -d #@db_name -h #@db_host -U #@db_user -w -f #@tmp_backup/#{dump_file_name}"
            exec_command(pg_dump_command)
            compress_file("#@tmp_backup/#{dump_file_name}")
          else
            raise "Dir #@tmp_backup doesn't exists"
          end
        rescue Exception => e
          @logger.error e.message
        end
      end

      public
      def run_file_system_backup
        begin
          @logger.info "Running run_file_system_backup"
          tar_file_name = "#@uploads_path_name-#@date.tar.gz"
          tar_command = "tar -czf #@tmp_backup/#{tar_file_name} #@uploads_path"
          exec_command(tar_command)
        rescue Exception => e
          @logger.error e.message
        end
      end
    end
  end
end
