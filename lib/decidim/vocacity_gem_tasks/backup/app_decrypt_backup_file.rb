# frozen_string_literal: true

require "openssl"

module Decidim
  module VocacityGemTasks
    class AppDecryptBackupFile
      attr_accessor :file_path

      def initialize(file_enc)
        logger.info "⚙️ starts decrypt file"
        raise ArgumentError, "encrypted file cannot be nil" if file_enc.nil?
        @file_enc = file_enc
      end
    
      def decrypt!
        setup_decipher!
        file_name = File.basename(@file_enc, ".enc")
        @file_path = File.join(File.dirname(@file_enc), file_name)

        File.open(@file_path, "w:BINARY") do |decrypted_file|     
          File.open(@file_enc, "r:BINARY") do |encrypted_file|
            data = encrypted_file.read
            decrypted_data = @decipher.update(data) + @decipher.final
            decrypted_file.write(decrypted_data)
          end
        end
        raise Error, "decrypted file not created" unless File.exists?(@file_path)
      rescue Exception => e
        logger.error e.message
        raise e
      end

      def setup_decipher!
        @decipher ||= OpenSSL::Cipher::AES.new(256, :CBC).decrypt        
        @decipher.key = Base64.decode64(ENV.fetch("BACKUP_CIPHER_KEY"))
        @decipher.iv = Base64.decode64(ENV.fetch("BACKUP_CIPHER_IV"))
      rescue Exception => e
        logger.error e.message
        raise e
      end

      ##
      # Define logger for the class.
      def logger
        @logger ||= Rails.logger
      end

    end
  end
end