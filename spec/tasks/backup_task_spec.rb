# frozen_string_literal: true

require "spec_helper"
require "decidim/vocacity_gem_tasks"

describe "VocacityGemTasks" do

  context "when initialize AppBackup" do 
    let(:app_backup) { Decidim::VocacityGemTasks::AppBackup }
    let(:logger) { instance_double("Logger") }
    let(:backup_runner_stub) { instance_double('Decidim::VocacityGemTasks::AppBackup.new') }
    let(:backup_runner) { Decidim::VocacityGemTasks::AppBackup.new }

    before do
      expect(logger).to receive(:info).with(anything)
    end

    it "should inicialize AppBackup" do
      logger.info("mock")
      expect(app_backup).to receive(:new)
      app_backup.new
    end
    
    it "should call check_pgpass" do
      logger.info("mock")
      expect(backup_runner_stub).to receive(:check_pgpass).and_return(File.exists?("/root/.pgpass"))
      backup_runner_stub.check_pgpass
    end

    it "should call run!" do
      logger.info("mock")
      expect(backup_runner).to receive(:run!).and_return(/-backup\.tar\.gz/)
      backup_runner.run!
    end

  end
end
