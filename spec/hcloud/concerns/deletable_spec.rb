# frozen_string_literal: true

RSpec.describe HCloud::Deletable do
  subject(:resource) { resource_class.new }

  include_context "resource"

  describe "#delete" do
    it "deletes the resource" do
      stub_request(:delete, "https://api.hetzner.cloud/v1/resources/#{resource.id}")
        .to_return(body: {}.to_json)

      resource.delete

      expect(resource).to be_deleted
    end
  end
end
