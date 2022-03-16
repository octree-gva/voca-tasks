# frozen_string_literal: true

require "spec_helper"
<<<<<<< HEAD

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
=======
describe "VocacityGemTasks" do

  context "when initialize AppBackup" do
    let!(:logger) { instance_double("Logger") }
    let(:app_backup) { VocacityGemTasks::AppBackup }
    let!(:backup_runner) { VocacityGemTasks::AppBackup.new }
    let(:check_pgpass) { backup_runner.send(:check_pgpass) }
    let(:file_pgpass) { File.exists?("/root/.pgpass") }
    let!(:dir) { Dir.mktmpdir }
    let(:dump_file) { backup_runner.send(:dump_database, dir) }
    let(:compressed_file) { backup_runner.send(:compress_uploads, dir) }
    let(:file_metadata) { backup_runner.send(:generate_metadatas, dir) }

    before do
      expect(logger).to receive(:info).with(anything)
    end

    it "should inicialize AppBackup" do
      logger.info("mock")
      expect(app_backup).to receive(:new).and_return(nil)
      app_backup.new
      expect(check_pgpass).to be nil
      expect(file_pgpass).to be true
    end

    it "should call run!" do
      logger.info("mock")
      expect(backup_runner).to receive(:run!)
      backup_runner.run!
>>>>>>> c541347 (chore: refactor files and splits class.)
    end
  end
end
