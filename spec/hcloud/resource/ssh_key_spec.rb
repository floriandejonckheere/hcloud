# frozen_string_literal: true

RSpec.describe HCloud::SSHKey do
  subject(:resource) { build(:ssh_key) }

  it "has default labels" do
    expect(described_class.new.labels).to eq({})
  end

  describe ".find" do
    it "returns an instance of the resource" do
      stub_request(:get, "https://api.hetzner.cloud/v1/ssh_keys/#{resource.id}")
        .to_return(body: { ssh_key: resource.attributes }.to_json)

      expect(described_class.find(resource.id).attributes).to eq resource.attributes
    end
  end
end
