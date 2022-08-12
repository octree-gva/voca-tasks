# frozen_string_literal: true

require "decidim/voca"

def task_succeeded(task, metadata = {})
  metadata[:ok] = true

  metadata[:time] = DateTime.now.strftime("%Q")
  Decidim::Voca::WebhookNotifierJob.perform_now(metadata, "decidim.#{task}")
  puts "task succeed"
end

def task_failed(task, error, metadata = {})
  metadata[:ok] = false
  metadata[:message] = "#{error}"
  metadata[:time] = DateTime.now.strftime("%Q")
  puts "task failed", "#{error}"
  Decidim::Voca::WebhookNotifierJob.perform_now(metadata, "decidim.#{task}")
  puts "task failed", "#{error}"
end

namespace :voca do
  desc """
    Execute PG_DUMP for decidim database, tar.gz
    for $RAILS_ROOT/public/uploads and stores in vocacity
    backup storage
  """

  desc "Backup Decidim Resources"
  task :backup, [:folder] => :environment do |t, args|
    args.with_defaults(folder: "hebdomadaire")
    backup_runner = Decidim::Voca::AppBackup.new
    backup_file = backup_runner.run!
    backup_file_encrypter = Decidim::Voca::AppEncryptBackupFile.new(backup_file)
    backup_file_encrypter.encrypt!
    backup_file_encrypted = backup_file_encrypter.file_enc
    backup_uploader = Decidim::Voca::Uploader.new(backup_file_encrypted, args[:folder])
    backup_uploader.upload!
    Rails.logger.info "⚙️ voca:backup done. (#{backup_file_encrypted})"
    task_succeeded("backup", { file: backup_file_encrypted })
  rescue Exception => e
    task_failed("backup", e)
  end

  desc """Send webhook
  Send a webhook to the ENV['WEBHOOK_URL']

  Example
  rails voca:webhook payload='{\'precompiled\':true, \'msg\':\'assets precompiled\'}' name='decidim.assets_compiled' now='true'
  """
  task webhook: :environment do
    payload = JSON[ENV.fetch("payload", "{}")]
    name = ENV.fetch("name", "decidim")
    is_perform_now = ENV.fetch("now", "false") == "true"
    if is_perform_now
      Decidim::Voca::WebhookNotifierJob.perform_now(payload, name)
    else
      Decidim::Voca::WebhookNotifierJob.perform_later(payload, name)
    end
  end

  desc "Execute a command "
  task command: :environment do
    vars = JSON[ENV.fetch("vars", "{}")]
    name = ENV.fetch("name", "backup").strip
    Decidim::Voca::CommandJob.perform_now(name, vars)
    task_succeeded("command", { enqueued: name })
  rescue Exception => e
    task_failed("command", e)
  end

  desc """Update decidim host
  Update the host with the given host argument

  Example
  rails voca:update:host host='test.ch'
  """
  task "update:host": :environment do
    new_host = ENV.fetch("host", "")
    raise "host not found" unless new_host.present?

    Decidim::Voca::Updater.update! host: new_host
    task_succeeded("update_host", { data: { host: new_host } })
    rescue Exception => e
      task_failed("update_host", e)
  end
end
