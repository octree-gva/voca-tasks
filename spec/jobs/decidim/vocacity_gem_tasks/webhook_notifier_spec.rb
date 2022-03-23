
module Decidim::VocacityGemTasks
  describe WebhookNotifierJob do
    let(:net_stub) do
      class NetStub; end
      net_stub = NetStub.new
      allow(net_stub).to receive(:post)
      net_stub
    end

    let(:logger) { Logger.new($stdout) }

    before(:each) do
      http_net = class_double("Net::HTTP").as_stubbed_const()
      allow(http_net).to receive(:new).and_return(net_stub)
    end

    subject { described_class }

    it "should send a request to <WEBHOOK_URL>/<INSTANCE_UUID>" do
      expect(Net::HTTP).to receive(:new).with("webhook_url", 80)
      expect(net_stub).to receive(:post).with(
        "/instance_uuid",
        anything,
        anything
      )
      subject.perform_now({ foo: "bar" }, "decidim.test", logger)
    end

    it "should sign the payload with HMAC256 <WEBHOOK_HMAC>" do
      # HMAC will produce a salted hash, so we stub it to check how it
      # was initialized
      allow(OpenSSL::HMAC).to receive(:hexdigest).and_return("signed_payload")
      payload = { foo: "bar", "do_something_wired": "but signed" }

      # ENV["WEBHOOK_HMAC"] is used?
      expect(OpenSSL::HMAC).to receive(:hexdigest).with(anything, "webhook_hmac", anything)
      # Signature is sent?
      expect(net_stub).to receive(:post).with(
        anything,
        {
          event_type: "decidim.test",
          content: payload.to_json,
          content_hmac: "signed_payload"
        }.to_json,
        anything
      )
      subject.perform_now(payload, "decidim.test", logger)
    end

  end
end
