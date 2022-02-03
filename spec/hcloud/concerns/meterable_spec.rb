# frozen_string_literal: true

RSpec.describe HCloud::Meterable do
  subject(:resource) { ExampleResource.new(id: 1) }

  describe "#metrics" do
    it "raises when no id was present" do
      resource.id = nil

      expect { resource.metrics(type: :type, from: 1.minute.ago, to: 1.second.ago) }.to raise_error HCloud::Errors::MissingIDError
    end

    it "fetches the metrics" do
      from = 1.minute.ago
      to = 1.second.ago

      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/metrics")
        .with(query: { type: "type", start: from.iso8601, end: to.iso8601 })
        .to_return(body: { metrics: {} }.to_json)

      metrics = resource.metrics(type: :type, from: from, to: to)

      expect(metrics).not_to be_nil
    end
  end
end
