# frozen_string_literal: true

source "https://rubygems.org"

base_path = ""
base_path = "../../" if File.basename(__dir__) == "dummy"
require_relative "#{base_path}lib/decidim/vocacity_gem_tasks/version"

DECIDIM_VERSION = Decidim::VocacityGemTasks.version

gem "decidim", DECIDIM_VERSION
gem "decidim-vocacity_gem_tasks", path: "."
gem "sqlite3"
gem "bootsnap", "~> 1.4"
gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

group :development, :test do
    gem "byebug", "~> 11.0", platform: :mri
    gem "dalli", "~> 2.7", ">= 2.7.10" # For testing MemCacheStore
    gem "decidim-consultations", DECIDIM_VERSION
    gem "decidim-dev", DECIDIM_VERSION
    gem "rubocop"
    gem "rubocop-faker"
    gem "rubocop-performance", "~> 1.6.0"
    gem "database_cleaner-active_record"
end

group :development do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.4", ">= 1.4.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.7", ">= 3.7.0"
end

group :test do
  gem "codecov", require: false
end
