# frozen_string_literal: true

require "spec_helper"

describe "VocacityGemTasks::AppBackup" do
  context "#run!" do
    let(:dir_klass) {class_double("Dir").as_stubbed_const()}

    it "creates a temp directory" do
      expect(dir_klass).to receive(:mktmpdir).with(any_args)
      VocacityGemTasks::AppBackup.new.run!
    end

    it "dump_database,compress_uploads and generate_metadatas with the fresh dir" do
      class DirStub
        def self.mktmpdir(&block)
          block.call("my-dirname")
        end
      end
      runner = VocacityGemTasks::AppBackup.new
      expect(runner).to receive(:dump_database).with("my-dirname")
      expect(runner).to receive(:compress_uploads).with("my-dirname")
      expect(runner).to receive(:generate_metadatas).with("my-dirname")
      
      stub_const("Dir", DirStub)
      allow(runner).to receive(:dump_database).and_return(nil)
      allow(runner).to receive(:compress_uploads).and_return(nil)
      allow(runner).to receive(:generate_metadatas).and_return(nil)
      allow(runner).to receive(:with_backup_dir).and_return(nil)
      runner.run!
    end
  end
end
