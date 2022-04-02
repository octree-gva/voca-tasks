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
    backup_uploader = Decidim::VocacityGemTasks::AppUploadToS3.new(backup_file: backup_file)
    if backup_uploader.run_uploader?
      Rails.logger.info "⚙️ vocacity:backup done. (#{backup_file})"
    else
      Rails.logger.error "⚙️ vocacity:backup fail. (#{backup_file})"
    end
  end

  desc "Send webhook"
  task webhook: :environment do
    payload = JSON[ENV.fetch("payload", "{}")]
    name = ENV.fetch("name", "decidim")
    is_perform_now = ENV.fetch("now", "false") == "true"
    if is_perform_now
      Decidim::VocacityGemTasks::WebhookNotifierJob.perform_now(payload, name)
    else
      Decidim::VocacityGemTasks::WebhookNotifierJob.perform_later(payload, name)
    end
  end

  desc "Execute a command "
  task command: :environment do
    vars = JSON[ENV.fetch("vars", "{}")]
    name = ENV.fetch("name", "backup").strip
    Decidim::VocacityGemTasks::CommandJob.perform_now(name, vars)
  end
end
