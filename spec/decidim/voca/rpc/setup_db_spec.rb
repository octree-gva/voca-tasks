# frozen_string_literal: true

require "spec_helper"

module Decidim::Voca
describe Decidim::Voca::DecidimServiceController do

    let(:empty) { ::Google::Protobuf::Empty.new }
    def subject
      run_rpc(
        :SetupDB,
        empty
      )
    end

    let(:net_stub) do
      class NetStub; end
      net_stub = NetStub.new
      allow(net_stub).to receive(:post)
      net_stub
    end

    before(:each) do
      http_net = class_double("Net::HTTP").as_stubbed_const()
      allow(http_net).to receive(:new).and_return(net_stub)
      DatabaseCleaner.clean
    end
    
    it "creates an organization with dummy hosts" do
      expect do
        subject
      end.to change { Decidim::Organization.count }.from(0).to(1)
      expect(Decidim::Organization.first.host).to eq "localhost"
      expect(Decidim::Organization.first.name).to eq "parked instance"
      expect(Decidim::Organization.first.reference_prefix).to eq "DOC"
    end

    it "defines basic content blocks" do
      expect do
        subject
      end.to change { Decidim::ContentBlock.count }.by_at_least(2)
    end
  end
end
