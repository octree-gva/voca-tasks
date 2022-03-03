require "decidim/vocacity_gem_tasks"

namespace :vocacity do
  desc "Execute PG_DUMP for decidim database, tar.gz for $RAILS_ROOT/public/uploads and stores in vocacity backup storage"

  @bkp = Decidim::VocacityGemTasks::AppBackup.new

  def dump_backup
    @bkp.run_pg_dump
  end

  def public_uploads_backup
    @bkp.run_file_system_backup
  end

  desc "Backup Decidim Resources"
  task backup: :environment do
    dump_backup
    public_uploads_backup
  end

end
