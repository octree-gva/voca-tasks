# frozen_string_literal: true

require "spec_helper"
require "decidim/vocacity_gem_tasks"

describe "VocacityGemTasks" do

  context "when initialize AppBackup" do 
    let!(:logger) { instance_double("Logger") }
    let(:app_backup) { Decidim::VocacityGemTasks::AppBackup }
    let!(:backup_runner) { Decidim::VocacityGemTasks::AppBackup.new }
    let(:check_pgpass) { backup_runner.send(:check_pgpass) }
    let(:file_pgpass) { File.exists?("/root/.pgpass") }
    let!(:dir) { Dir.mktmpdir }
    let(:dump_file) { backup_runner.send(:dump_database, dir) }
    let(:compressed_file) { backup_runner.send(:compress_uploads, dir) }
    let(:file_metadata) { backup_runner.send(:generate_metadatas, dir) }
    let(:backup_dir) { "#{ENV.fetch('RAILS_ROOT')}/decidim-module-vocacity_gem_tasks/backup_dir" }
    let(:block) { backup_file = "-backup.tar.gz" }
    let(:with_backup_dir) { backup_runner.send(:with_backup_dir) }

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
    end

    it "should execute private methods" do
      expect(dump_file).to match(/\.dump/)
      expect(compressed_file).to match(/\.tar\.gz/)
      expect(file_metadata).to match(/metadatas\.json/)
      expect(with_backup_dir).to receive(:call)
    end

  end
end
