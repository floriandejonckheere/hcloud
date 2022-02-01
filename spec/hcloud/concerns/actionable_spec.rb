# frozen_string_literal: true

RSpec.describe HCloud::Actionable do
  subject(:resource) { ExampleResource.new(id: 1) }

  describe "#actions" do
    it "lists all actions" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/actions")
        .with(query: { page: 1, per_page: 50 })
        .to_return(body: { actions: [{ id: 1, command: "create_resource" }], meta: { pagination: { total_entries: 1 } } }.to_json)

      actions = resource.actions

      expect(actions.count).to eq 1
      expect(actions.first.id).to eq 1
    end

    it "finds an action" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/actions/1")
        .to_return(body: { action: { id: 1, command: "create_resource" } }.to_json)

      actions = resource.actions.find(1)

      expect(actions.command).to eq "create_resource"
    end
  end

  describe "#resize" do
    it "raises when no id was present" do
      resource.id = nil

      expect { resource.resize(size: 100) }.to raise_error HCloud::Errors::MissingIDError
    end

    it "creates an action" do
      stub_request(:post, "https://api.hetzner.cloud/v1/examples/#{resource.id}/actions/resize")
        .with(body: { size: 100 })
        .to_return(body: { action: { id: 1, command: "resize" } }.to_json)

      action = resource.resize(size: 100)

      expect(action.command).to eq "resize"
    end
  end
end
