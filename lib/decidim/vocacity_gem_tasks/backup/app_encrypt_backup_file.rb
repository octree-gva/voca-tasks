# frozen_string_literal: true

require "openssl"

module Decidim
  module VocacityGemTasks
    class AppEncryptBackupFile
      attr_accessor :file_enc, :cipher, :file_path

      def initialize(file_path)
        logger.info "⚙️ starts encrypt file"
        raise ArgumentError, "file cannot be nil" if file_path.nil?
        @file_path = file_path
      end
    
      def encrypt!
        setup_cipher!
        @file_enc = @file_path+".enc"
        File.open(@file_enc, "w:BINARY") do |encrypted_file|     
          File.open(@file_path, "r:BINARY") do |file|
            data = file.read
            encrypted_data = @cipher.update(data) + @cipher.final
            encrypted_file.write(encrypted_data)
          end
        end
        raise Error, "encrypted file not created" unless File.exists?(@file_enc)
      rescue Exception => e
        logger.error e.message
        raise e
      end

      private
        def setup_cipher!
          @cipher ||= OpenSSL::Cipher::AES.new(256, :CBC).encrypt
          @cipher.key = Base64.decode64(ENV.fetch("BACKUP_CIPHER_KEY"))
          @cipher.iv = Base64.decode64(ENV.fetch("BACKUP_CIPHER_IV"))
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
