module Decidim
  module VocacityGemTasks
    class AppSendToS3
      def initialize
        logger.info "⚙️ starts send to S3"
      end

      def get_backup_file
      end

      def get_vocacity_bucket
      end

      def create_vocacity_client_dir
      end

      def send_backup_file
      end

      def get_backup_files(client_name)
      end
      
      def remove_backup_file(client_name, backup_file_name)
      end
      
    end
  end
end
