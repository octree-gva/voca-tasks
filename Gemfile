# frozen_string_literal: true

source "https://rubygems.org"

gem "decidim", "0.26.4"
gem "decidim-voca", path: "."

gem "aws-sdk-s3", "~> 1"
gem "gruf", "~> 2.14", ">= 2.14.1"
gem "bootsnap"

group :development, :test do
  gem "faker", "~> 2.14"
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "0.26.4"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
end

group :test do
  gem "database_cleaner-active_record"
  gem "codecov", require: false
  gem 'gruf-rspec', require: false
  gem "mock_redis", require: false
end
