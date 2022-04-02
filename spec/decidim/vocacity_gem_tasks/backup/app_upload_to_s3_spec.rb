# frozen_string_literal: true

require "spec_helper"

require 'aws-sdk-s3'

describe "VocacityGemTasks::AppUploadToS3" do

  let(:backup_file_path) { "/path_to_backup_dir/backup.tar.gz" }
  let(:s3) { Aws::S3::Resource.new(stub_responses: true) }

  context "#run_uploader?" do

    it "when inicialize class" do
      backup_uploader = class_double("Decidim::VocacityGemTasks::AppUploadToS3")
      expect(backup_uploader).to receive(:new).with(backup_file: backup_file_path)
      backup_uploader.new(backup_file: backup_file_path)
    end
  
    it "when uploads backup_file, get_vocacity_bucket and upload_backup_file" do
      backup_uploader = Decidim::VocacityGemTasks::AppUploadToS3.new(backup_file: backup_file_path)
      expect(backup_uploader).to receive(:get_vocacity_bucket)
      expect(backup_uploader).to receive(:upload_backup_file?)

      s3.client.stub_responses(:list_buckets, {buckets: [{ name: 'vocacity' }]})
      allow(backup_uploader).to receive(:get_vocacity_bucket).and_return(s3)
      allow(backup_uploader).to receive(:upload_backup_file?).and_return(true)
      backup_uploader.run_uploader?
    end

  end

end
