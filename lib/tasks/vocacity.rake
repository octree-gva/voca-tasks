# frozen_string_literal: true

require "decidim/vocacity_gem_tasks"

def task_succeeded(task, metadata = {})
  metadata[:ok] = true
  
  metadata[:time] = DateTime.now.strftime("%Q")
  Decidim::VocacityGemTasks::WebhookNotifierJob.perform_later(metadata, "decidim.#{task}")
  puts "task succeed"
end

def task_failed(task, error, metadata = {})
  metadata[:ok] = false
  metadata[:message] = "#{error}"
  metadata[:time] = DateTime.now.strftime("%Q")
  puts "task failed", "#{error}"
  Decidim::VocacityGemTasks::WebhookNotifierJob.perform_later(metadata, "decidim.#{task}")
  puts "task failed", "#{error}"
end

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
    task_succeeded("backup", { file: backup_file })
  rescue Exception => e
    task_failed("backup", e)
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
    task_succeeded("command", { enqueued: name })
  rescue Exception => e
    task_failed("command", e)
  end

  desc "Seed a minial instance"
  task seed: :environment do
    seed_data = {
      "system_admin_email": ENV.fetch("system_admin_email"),
      "system_admin_password": ENV.fetch("system_admin_password"),
      "admin_email": ENV.fetch("admin_email"),
      "org_name": ENV.fetch("org_name"),
      "org_prefix": ENV.fetch("org_prefix"),
      "host": ENV.fetch("host"),
      "default_locale": ENV.fetch("default_locale"),
      "available_locales": ENV.fetch("available_locales")
    }
    Decidim::VocacityGemTasks::Seed.seed! seed_data
    task_succeeded("seed", { data: seed_data })
    rescue Exception => e
      task_failed("seed", e)
  end
end
