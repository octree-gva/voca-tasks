# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Decidim
  module Voca
    class WebhookNotifierJob < ApplicationJob
      queue_as :default
      attr_reader :event_type
      def perform(content, event_type, logger = Rails.logger)
        @content = content
        @event_type = event_type
        @logger = logger
        notify!
      end

        private

          def hmac_key
            @hmac_key ||= ENV.fetch("WEBHOOK_HMAC", "insecure_secret")
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
            header = {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "User-Agent": "VocaCity/0.0.1"
            }
            http = Net::HTTP.new(webhook_uri.host, webhook_uri.port)
            response = http.post(webhook_uri.request_uri, payload.to_json, header)
          end
    end
  end
end
