require "net/http"
require "uri"
require "json"
module Decidim
  module VocacityGemTasks
    class WebhookNotifierJob < ApplicationJob
      queue_as :default

      def perform(content, event_type, logger = Rails.logger)
        @content = content
        @event_type = event_type
        @logger = logger
        notifiy!
      end

        private

          def hmac_key
            @hmac_key ||= ENV.fetch("WEBHOOK_HMAC")
          end

          def content
            @content.to_json
          end

          def webhook_uri
            webhook_url = ENV.fetch("WEBHOOK_URL") + "/" + ENV.fetch("INSTANCE_UUID")
            URI.parse(webhook_url)
          end

          def payload
            {
                event_type: event_type,
                content: content,
                content_hmac: OpenSSL::HMAC.hexdigest(
                  OpenSSL::Digest.new("sha256"),
                    hmac_key,
                    content
                )
            }
          end

          def notify!
            header = { "Content-Type": "text/json" }
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = payload.to_json
            response = http.request(request)
          end
    end
  end
end
