# frozen_string_literal: true

require "spec_helper"

describe "VocacityGemTasks::AppDecryptBackupFile" do

  let(:backup_file_path) { "/path_to_backup_dir/decrypted-backup.tar.gz" }
  let(:backup_file_enc_path) { "/path_to_backup_dir/backup.tar.gz.enc" }
  let(:decipher) { instance_double("OpenSSL::Cipher::AES.new(256, :CBC).decrypt") }

  context "#encrypt_backup_file" do

    it "when inicialize class" do
      backup_file_decrypter = class_double("Decidim::VocacityGemTasks::AppDecryptBackupFile")
      expect(backup_file_decrypter).to receive(:new).with(backup_file_enc: backup_file_enc_path)
      backup_file_decrypter.new(backup_file_enc: backup_file_enc_path)
    end
  
    it "when decrypts backup_file_enc, get_decipher and decrypt_backup_file" do
      backup_file_decrypter = Decidim::VocacityGemTasks::AppDecryptBackupFile.new(backup_file_enc: backup_file_enc_path)
      expect(backup_file_decrypter).to receive(:decrypt_backup_file)

      allow(backup_file_decrypter).to receive(:get_decipher).and_return(decipher)
      allow(backup_file_decrypter).to receive(:decrypt_backup_file).and_return(backup_file_path)
      backup_file_decrypter.decrypt_backup_file
    end

  end

end
