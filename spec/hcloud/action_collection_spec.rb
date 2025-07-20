# frozen_string_literal: true

RSpec.describe HCloud::ActionCollection do
  let(:collection) { described_class.new(:action, resource) }

  let(:resource) { ExampleResource.new(id: 1) }

  describe "#find" do
    it "finds an action" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/actions/1")
        .to_return(body: { action: { id: 1, command: "create_resource" } }.to_json)

      actions = collection.find(1)

      expect(actions.command).to eq "create_resource"
    end
  end
end
