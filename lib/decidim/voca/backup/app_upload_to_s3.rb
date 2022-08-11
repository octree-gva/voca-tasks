# frozen_string_literal: true

require "aws-sdk-s3"

module Decidim
  module Voca
    class Uploader
      attr_accessor :filename, :folder

      def initialize(filename, folder)
        logger.info "⚙️ starts upload file to S3"
        raise ArgumentError, "filename cannot be nil" if filename.nil?
        @filename = filename
        raise ArgumentError, "folder cannot be nil" if folder.nil?
        @folder = folder
      end

      def upload!
        instance_uuid = ENV.fetch("INSTANCE_UUID")
        destination = File.join(
          "#{instance_uuid}/",
          "#{@folder}/",
          File.basename(filename)
        )
        logger.info "Uploading file: #{@filename} for client: #{instance_uuid}"
        bucket.object(destination).upload_file(filename)
        logger.info "Backup file: #{@filename} upload success"
      rescue Exception => e
        logger.error e.message
        raise e
      end

      private
        def bucket
          s3_endpoint ||= ENV.fetch("ENDPOINT") unless nil
          s3 ||= Aws::S3::Resource.new(endpoint: "#{s3_endpoint}")
          s3_bucket = s3.bucket("vocacity")
          raise Error if s3_bucket.name.nil?
          s3_bucket
        end

        ##
        # Define logger for the class.
        def logger
          @logger ||= Rails.logger
        end
    end
  end
end
