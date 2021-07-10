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

      model = described_class.find(resource.id)

      expect(model).to be_a described_class
      expect(model.attributes).to eq resource.attributes
    end
  end

  describe ".all" do
    it "returns instances of the resource" do
      stub_request(:get, "https://api.hetzner.cloud/v1/ssh_keys")
        .to_return(body: { ssh_keys: [resource.attributes] }.to_json)

      models = described_class.all

      expect(models.count).to eq 1
      expect(models.first).to be_a described_class
      expect(models.first.attributes).to eq resource.attributes
    end
  end
end
