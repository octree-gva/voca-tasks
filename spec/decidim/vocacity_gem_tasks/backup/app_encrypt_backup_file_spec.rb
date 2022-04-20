# frozen_string_literal: true

require "spec_helper"

describe "VocacityGemTasks::AppEncryptBackupFile" do

  let(:backup_file_path) { "/path_to_backup_dir/backup.tar.gz" }
  let(:backup_file_enc_path) { "/path_to_backup_dir/backup.tar.gz.enc" }
  let(:cipher) { instance_double("OpenSSL::Cipher::AES.new(256, :CBC).encrypt") }

  context "#encrypt_backup_file" do

    it "when inicialize class" do
      backup_file_encrypter = class_double("Decidim::VocacityGemTasks::AppEncryptBackupFile")
      expect(backup_file_encrypter).to receive(:new).with(backup_file: backup_file_path)
      backup_file_encrypter.new(backup_file: backup_file_path)
    end
  
    it "when encrypts backup_file, get_cipher and encrypt_backup_file" do
      backup_file_encrypter = Decidim::VocacityGemTasks::AppEncryptBackupFile.new(backup_file: backup_file_path)
      expect(backup_file_encrypter).to receive(:encrypt_backup_file)
      
      allow(backup_file_encrypter).to receive(:get_cipher).and_return(cipher)
      allow(backup_file_encrypter).to receive(:encrypt_backup_file).and_return(backup_file_enc_path)
      backup_file_encrypter.encrypt_backup_file
    end

  end

end
