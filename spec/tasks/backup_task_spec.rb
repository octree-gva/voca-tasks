# frozen_string_literal: true

require "spec_helper"

require "decidim/vocacity_gem_tasks"

require "rake"


describe "AppBackup" do    
    it "initialize AppBackup" do
        expect { Decidim::VocacityGemTasks::AppBackup.new }.not_to raise_error
    end
end

describe "AppBackup" do    
    it "run run_pg_dump" do
        app_backup = Decidim::VocacityGemTasks::AppBackup.new
        expect { app_backup.run_pg_dump }.not_to raise_error
    end
end

describe "AppBackup" do    
    it "run public_upload_backup" do
        app_backup = Decidim::VocacityGemTasks::AppBackup.new
        expect { app_backup.run_file_system_backup }.not_to raise_error
    end
end
