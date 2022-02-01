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
  end
end
