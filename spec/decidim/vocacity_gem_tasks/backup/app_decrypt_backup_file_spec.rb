# frozen_string_literal: true

require "spec_helper"

describe "VocacityGemTasks::AppDecryptBackupFile" do

  let(:backup_file_path) { "/path_to_backup_dir/decrypted-backup.tar.gz" }
  let(:backup_file_enc_path) { "/path_to_backup_dir/backup.tar.gz.enc" }
  let(:decipher) { instance_double("OpenSSL::Cipher::AES.new(256, :CBC).decrypt") }

  context "#decrypt_backup_file" do

    it "when inicialize class" do
      backup_file_decrypter = class_double("Decidim::VocacityGemTasks::AppDecryptBackupFile")
      expect(backup_file_decrypter).to receive(:new).with(backup_file_enc_path)
      backup_file_decrypter.new(backup_file_enc_path)
    end
  
    it "when decrypts backup_file_enc, decipher! and decrypt!" do
      backup_file_decrypter = Decidim::VocacityGemTasks::AppDecryptBackupFile.new(backup_file_enc_path)
      expect(backup_file_decrypter).to receive(:decrypt!)
      expect(backup_file_decrypter).to receive(:file_path)

      allow(backup_file_decrypter).to receive(:decipher!).and_return(nil)
      allow(backup_file_decrypter).to receive(:decrypt!).and_return(nil)
      allow(backup_file_decrypter).to receive(:file_path).and_return(backup_file_path)
      backup_file_decrypter.decrypt!
      backup_file_decrypter.file_path
    end

  end

end
