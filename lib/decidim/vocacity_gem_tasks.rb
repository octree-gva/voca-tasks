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
      def initialize
        logger.info "⚙️ starts backup (##{now})"
        check_pgpass
      end

      def backup_db!
        logger.debug "Running backup_db!"
        with_backup_dir do |backup_dir|
          db_host = ENV.fetch("DATABASE_HOST")
          db_user = ENV.fetch("DATABASE_USERNAME")
          db_pass = ENV.fetch("DATABASE_PASSWORD")
          db_name = ENV.fetch('DATABASE_DATABASE')

          dump_file = "#{backup_dir}/#{db_name}-#{now}.dump"
          exec_command!("pg_dump -v -Fc \
            -d #{db_name} -h #{db_host} -U #{db_user} -w \
            -f #{dump_file}")

          gzip_file! "#{dump_file}"
          logger.info "⚙️ backup db: #{dump_file}"
        end
      rescue Exception => e
        logger.error e.message
        raise e
      end

      def backup_uploads!
        logger.debug "Running backup_uploads!"
        with_backup_dir do |backup_dir| 
          compressed_file = "#{backup_dir}/#{uploads_path_name}-#{now}.tar.gz"
          tar_file!("#{uploads_path}", "#{compressed_file}")
          logger.info "⚙️ backup uploads: #{compressed_file}"
        end
      rescue Exception => e
        logger.error e.message
        raise e
      end

      private
      def check_pgpass
        # Check /root/.pgpass exists if not create it
        File.open("/root/.pgpass", "w") do |f| 
          db_host = ENV.fetch("DATABASE_HOST")
          db_user = ENV.fetch("DATABASE_USERNAME")
          db_pass = ENV.fetch("DATABASE_PASSWORD")
          db_name = ENV.fetch('DATABASE_DATABASE')
          f.write("#{db_host}:*:#{db_name}:#{db_user}:#{db_pass}")
          f.chmod(0600)
        end unless File.exists?("/root/.pgpass")
      end

      def exec_command!(command)
        logger.debug "exec '#{command}'"
        command_output = system(command)
        if command_output == true
          logger.debug "The command: #{command} has worked"
        else
            raise "The command: #{command} has failed"
        end
      rescue Exception => e
        logger.error e.message
        raise e
      end

      def with_backup_dir(&block)
        @backup_dir ||= "#{ENV.fetch('RAILS_ROOT')}/decidim-module-vocacity_gem_tasks/backup_dir"
        backup_dir = @backup_dir
        Dir.mkdir(backup_dir) unless Dir.exists?(backup_dir)
        if Dir.exists?(backup_dir)
          block.call(backup_dir)
        else
          raise "Fails to create #{backup_dir}"
        end
      end

      def gzip_file!(file)
        if File.exists?(file)
          compress_command = "gzip #{file}"
          exec_command!(compress_command)
        else
          raise "File #{file} doesn't exists"
        end
      rescue Exception => e
        logger.error e.message
        raise e
      end

      def tar_file!(source, destination)
        exec_command! "tar -czf #{destination} #{source}"
      rescue Exception => e
        logger.error "can not tar file."
        logger.error e.message
        raise e
      end
      ##
      # Define logger for the class.
      def logger
        @logger ||= Rails.logger
      end

      ##
      # Time at the start of the backup task
      def now
        @now ||= Time.new.strftime("%Y-%m-%d_%H-%M-%S")
      end

      def uploads_path
        @uploads_path ||= ENV.fetch('RAILS_ROOT') + "/public/uploads"
      end

      def uploads_path_name
        @uploads_path_name ||= uploads_path.split("/")[-1]
      end
    end
  end
end
