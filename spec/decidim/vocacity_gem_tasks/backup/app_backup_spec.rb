# frozen_string_literal: true

require "spec_helper"

describe "VocacityGemTasks::AppBackup" do
  context "#run!" do
    let(:dir_klass) { class_double("Dir").as_stubbed_const() }
    let(:uploads_path_dir) { "/path_to_dir/uploads" }
    let(:logs_path_dir) { "/path_to_dir/log" }

    it "creates a temp directory" do
      expect(dir_klass).to receive(:mktmpdir).with(any_args)
      Decidim::VocacityGemTasks::AppBackup.new.run!
    end

    it "dump_database,compress_source_path and generate_metadatas with the fresh dir" do
      class DirStub
        def self.mktmpdir(&block)
          block.call("my-dirname")
        end
      end
      runner = Decidim::VocacityGemTasks::AppBackup.new
      expect(runner).to receive(:dump_database).with("my-dirname")
      expect(runner).to receive(:compress_source_path).with(uploads_path_dir, "my-dirname")
      expect(runner).to receive(:compress_source_path).with(logs_path_dir, "my-dirname")
      expect(runner).to receive(:generate_metadatas).with("my-dirname")

      stub_const("Dir", DirStub)
      allow(runner).to receive(:dump_database).and_return(nil)
      allow(runner).to receive(:compress_source_path).and_return(nil)
      allow(runner).to receive(:compress_source_path).and_return(nil)
      allow(runner).to receive(:generate_metadatas).and_return(nil)
      allow(runner).to receive(:with_backup_dir).and_return(nil)
      allow(runner).to receive(:uploads_path).and_return(uploads_path_dir)
      allow(runner).to receive(:logs_path).and_return(logs_path_dir)
      runner.run!
    end
  end
end
