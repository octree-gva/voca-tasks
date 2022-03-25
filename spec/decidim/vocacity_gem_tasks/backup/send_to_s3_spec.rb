# frozen_string_literal: true

require "spec_helper"

describe "VocacityGemTasks::AppSendToS3" do

  let(:sender) { instance_double("Decidim::VocacityGemTasks::AppSendToS3") }
  let(:backup_file) { class_double("File").as_stubbed_const }
  let(:list) { class_double("List").as_stubbed_const }

  context "#send!" do
    
    it "when gets a backup_file" do
      allow(sender).to receive(:get_backup_file).and_return(backup_file)
      backup_file_ = sender.get_backup_file
      expect(backup_file_).to be(backup_file)
    end

    it "when gets the vocacity_bucket from S3 buckets" do
      expect(sender).to receive(:get_vocacity_bucket).and_return(list)
      sender.get_vocacity_bucket
    end

    it "when creates a client dir on S3 if it not exists" do
      expect(sender).to receive(:create_vocacity_client_dir).and_return(true)
      sender.create_vocacity_client_dir
    end
 
    it "when sends the backup_file to client dir on S3" do
      expect(sender).to receive(:send_backup_file).and_return(true)
      sender.send_backup_file
    end

  end

  context "#get_backup_files" do
    it "when gets a list of files from a S3 client" do
      expect(sender).to receive(:get_backup_files).with('client_name').and_return(list)
      sender.get_backup_files("client_name")
    end
  end
  

  context "#remove_backup_file" do
    it "when removes a file from a S3 client" do
      expect(sender).to receive(:remove_backup_file).with('client_name', 'backup_file_name').and_return(true)
      sender.remove_backup_file("client_name", "backup_file_name")
    end
  end
  

end
