require 'aws-sdk-s3'

module Decidim
  module VocacityGemTasks
    class AppSendToS3
      def initialize(backup_file:)
        logger.info "⚙️ starts send to S3"
        raise ArgumentError, "backup_file cannot be nil" if backup_file.nil?
        @backup_file_path = backup_file
        @backup_file_name = File.basename(@backup_file_path)
      end

      def run_sender?
        client_uuid = ENV.fetch('INSTANCE_UUID')
        logger.info "Uploading backup file: #{@backup_file_name} for client: #{client_uuid}"
        s3_bucket = get_vocacity_bucket
        if upload_backup_file?(s3_bucket: s3_bucket, client_uuid: client_uuid)
          logger.info "Backup file: #{@backup_file_name} upload success"
          return true
        else
          logger.error "Backup file: #{@backup_file_name} upload fail"
          return false
        end
      rescue Exception => e
        logger.error e.message
        raise e
      end

      def list_backup_file_from_bucket(client_uuid:)
      end

      def get_backup_file_from_bucket(client_uuid:, backup_file_path:)
      end
      
      def remove_backup_file_from_bucket(client_uuid:, backup_file_path:)
      end

      ##
      # Define logger for the class.
      def logger
        @logger ||= Rails.logger
      end

      private
        def get_vocacity_bucket
          sos_endpoint ||= ENV.fetch("ENDPOINT") unless nil
          s3 ||= Aws::S3::Resource.new(endpoint: "#{sos_endpoint}")
          s3_bucket = s3.bucket('vocacity')
          raise StandardError if s3_bucket.name.nil?
          s3_bucket
        end

        def upload_backup_file?(s3_bucket:, client_uuid:)
          targetObj = s3_bucket.object("#{client_uuid}/#{@backup_file_name}")
          upload_result = targetObj.upload_file("#{@backup_file_path}")
          raise StandardError, "Backup upload failed for #{@backup_file_name}" unless upload_result
          upload_result
        end    
      
    end
  end
end
