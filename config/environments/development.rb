Rails.application.configure do
  Rails.logger = Logger.new(STDOUT)
  config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
  Rails.logger.level = Logger::DEBUG
  Rails.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
end
