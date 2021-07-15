# frozen_string_literal: true

RSpec.describe HCloud::SSHKey do
  subject(:resource) { build(:ssh_key) }

  it "has default labels" do
    expect(described_class.new.labels).to eq({})
  end

  describe "#create" do
    subject(:resource) { build(:ssh_key, id: nil, created: nil) }

    it "creates the resource" do
      stub_request(:post, "https://api.hetzner.cloud/v1/ssh_keys")
        .with(body: resource.attributes.slice(*resource.creatable_attributes.map(&:to_s)))
        .to_return(body: { ssh_key: resource.attributes.merge(id: 1, created: 1.second.ago) }.to_json)

      resource.create

      expect(resource.id).to eq 1
      expect(resource).to be_created
    end
  end

  describe "#update" do
    it "updates the resource" do
      stub_request(:put, "https://api.hetzner.cloud/v1/ssh_keys/#{resource.id}")
        .with(body: resource.attributes.slice(*resource.updatable_attributes.map(&:to_s)))
        .to_return(body: { ssh_key: resource.attributes.merge(name: "my_name") }.to_json)

      resource.update

      expect(resource.name).to eq "my_name"
    end
  end

  describe "#delete" do
    it "deletes the resource" do
      stub_request(:delete, "https://api.hetzner.cloud/v1/ssh_keys/#{resource.id}")
        .to_return(body: {}.to_json)

      resource.delete

      expect(resource).to be_deleted
    end
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
        .with(query: { page: 1, per_page: 50 })
        .to_return(body: { ssh_keys: [resource.attributes], meta: { pagination: { total_entries: 1 } } }.to_json)

      models = described_class.all

      expect(models.count).to eq 1
      expect(models.first).to be_a described_class
      expect(models.first.attributes).to eq resource.attributes
    end
  end
end
