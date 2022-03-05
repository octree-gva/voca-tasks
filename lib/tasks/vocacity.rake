require "decidim/vocacity_gem_tasks"

namespace :vocacity do
  desc """
    Execute PG_DUMP for decidim database, tar.gz 
    for $RAILS_ROOT/public/uploads and stores in vocacity 
    backup storage
  """

  desc "Backup Decidim Resources"
  task backup: :environment do
    backup_runner = Decidim::VocacityGemTasks::AppBackup.new
    backup_runner.backup_db!
    backup_runner.backup_uploads!
    Rails.logger.info "⚙️ vocacity:backup done."
  end

end
