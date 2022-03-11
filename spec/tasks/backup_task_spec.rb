# frozen_string_literal: true

require "spec_helper"
require "decidim/vocacity_gem_tasks"

describe "VocacityGemTasks" do

  context "when initialize AppBackup" do 
    let(:app_backup) { Decidim::VocacityGemTasks::AppBackup }
    let(:file) { class_double("File") }
    let(:logger) { instance_double("Logger") }
    let(:backup_runner_stub) { instance_double('Decidim::VocacityGemTasks::AppBackup.new') }
    let(:backup_runner) { Decidim::VocacityGemTasks::AppBackup.new }

    before do
      expect(logger).to receive(:info).with(anything)
    end

    after do
      expect(file).to receive(:exists?).with(anything)
    end

    it "should inicialize AppBackup" do
      logger.info("mock")
      expect(app_backup).to receive(:new)
      app_backup.new
      file.exists?("/root/.pgpass")
    end
  
    it "should call run!" do
      logger.info("mock")
      expect(backup_runner).to receive(:run!).and_return(/-backup\.tar\.gz/)
      backup_runner.run!
    end

  end
end
