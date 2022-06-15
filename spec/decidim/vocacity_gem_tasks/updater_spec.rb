require "spec_helper"

module Decidim::VocacityGemTasks
  describe Updater do
    subject { described_class }


    before(:each) do
      DatabaseCleaner.clean
    end
    
    let(:valid_options) do
      {
          "host": "example.ch",
          "available_locales": "en, ca"
      }
    end
    let(:organization) { create(:organization) }

    it "update the organization with the given options" do
      organization
      subject.update!(valid_options)
      organization.reload
      expect(organization.host).to eq("example.ch")
      expect(organization.available_locales).to eq(["en", "ca"])
    end

    it "update the organization with the given host option" do
      organization
      subject.update!({host: "test.ch"})
      expect(organization.reload.host).to eq("test.ch")
    end

    it "update the organization with the given host option" do
      expect do
        organization
        subject.update!({host: "test.ch"})
        organization.reload
      end.to change { organization.host }.to("test.ch")
    end
    

    it "split available_locales options to array" do
      expect do
        subject.update!({available_locales: "es, en"})
      end.to change { organization.reload.available_locales }.to(["es", "en"])
    end

    it "raises an error if trying to update a non existing attribute" do

      expect do
        subject.update!(foo: "bar")
      end.to raise_error(Decidim::VocacityGemTasks::Error)
    end

  end
end
