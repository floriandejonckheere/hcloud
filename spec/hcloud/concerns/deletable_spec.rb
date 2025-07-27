# frozen_string_literal: true

RSpec.describe HCloud::Deletable do
  subject(:resource) { ExampleResource.new(id: 1) }

  describe "#delete" do
    it "raises when no id was present" do
      resource.id = nil

      expect { resource.delete }.to raise_error HCloud::Errors::MissingIDError
    end

    it "deletes the resource" do
      stub_request(:delete, "https://api.hetzner.cloud/v1/examples/#{resource.id}")
        .to_return(body: {}.to_json)

      resource.delete

      expect(resource).to be_deleted
    end

    it "returns the resource" do
      stub_request(:delete, "https://api.hetzner.cloud/v1/examples/#{resource.id}")
        .to_return(body: {}.to_json)

      expect(resource.delete).to be_a described_class
    end

    context "when the API return an action" do
      it "returns the action" do
        stub_request(:delete, "https://api.hetzner.cloud/v1/examples/#{resource.id}")
          .to_return(body: { action: { id: 1, status: "running", command: "delete_resource" } }.to_json)

        action = resource.delete

        expect(action).to be_a HCloud::Action

        expect(action.id).to eq 1
        expect(action.status).to eq "running"
        expect(action.command).to eq "delete_resource"
      end
    end
  end
end
