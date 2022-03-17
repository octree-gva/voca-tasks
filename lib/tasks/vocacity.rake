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
    backup_file = backup_runner.run!

    Rails.logger.info "⚙️ vocacity:backup done. (#{backup_file})"
  end

end
