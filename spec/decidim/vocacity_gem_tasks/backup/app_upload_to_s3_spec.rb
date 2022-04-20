# frozen_string_literal: true

require "spec_helper"

describe "VocacityGemTasks::App" do

  let(:backup_file_path) { "/path_to_backup_dir/backup.tar.gz.enc" }
  let(:s3) { Aws::S3::Resource.new(stub_responses: true) }
  let(:folder) { "folder" }

  context "#run_uploader?" do

    it "when inicialize class" do
      backup_uploader = class_double("Decidim::VocacityGemTasks::Uploader")
      expect(backup_uploader).to receive(:new).with(backup_file_path, folder)
      backup_uploader.new(backup_file_path, folder)
    end
  
    it "when uploads backup_file, upload! and bucket" do
      backup_uploader = Decidim::VocacityGemTasks::Uploader.new(backup_file_path, folder)
      expect(backup_uploader).to receive(:upload!)

      s3.client.stub_responses(:list_buckets, {buckets: [{ name: 'vocacity' }]})
      allow(backup_uploader).to receive(:bucket).and_return(s3)
      allow(backup_uploader).to receive(:upload!).and_return(nil)
      backup_uploader.upload!
    end

  end

end

