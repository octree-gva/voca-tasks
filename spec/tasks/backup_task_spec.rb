# frozen_string_literal: true

require "spec_helper"
require "decidim/vocacity_gem_tasks"

describe "Backup Decidim Resources", type: :tasks do
    context "when run the backup tasks" do    
        it "should @return [String] the absolute path of the backuped file" do
            backup_runner = Decidim::VocacityGemTasks::AppBackup.new
            backup_file = backup_runner.run!
            expect(/backup\.tar\.gz/).to match(backup_file)
        end
    end
end
