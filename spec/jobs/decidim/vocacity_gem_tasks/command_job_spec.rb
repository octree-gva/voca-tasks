require "spec_helper"
module Decidim::VocacityGemTasks
  describe CommandJob do
      subject { described_class }
      it "can order a backup" do
        expect(Rake::Task["vocacity:backup"]).to receive(:invoke).with(nil)
        subject.perform_now("backup")
      end

      it "throws if a command does not exists in the vocacity namespace" do
        expect do
          subject.perform_now("db:migrate")
        end.to raise_error(Decidim::VocacityGemTasks::Error)
        expect do
          subject.perform_now("404")
        end.to raise_error(Decidim::VocacityGemTasks::Error)
      end

      it "pass vars arguments in tasks" do
        payload = {foo: :bar}.to_json
        expect(Rake::Task["vocacity:webhook"]).to receive(:invoke).with(
          "payload=\"#{payload}\" name=\"decidim.foobar\""
        )
        subject.perform_now("webhook", {payload: payload, name: "decidim.foobar"})
      end
    end
end
