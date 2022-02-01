# frozen_string_literal: true

RSpec.describe HCloud::Queryable do
  subject(:resource) { ExampleResource.new(id: 1) }

  describe "#reload" do
    it "raises when no id was present" do
      resource.id = nil

      expect { ExampleResource.find(nil) }.to raise_error HCloud::Errors::MissingIDError
    end

    it "reloads the resource" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}")
        .to_return(body: { example: resource.attributes.merge(name: "new_name") }.to_json)

      expect(resource.reload.name).to eq "new_name"
    end
  end

  describe ".find" do
    it "raises when no id was given" do
      expect { ExampleResource.find(nil) }.to raise_error HCloud::Errors::MissingIDError
    end

    it "returns an instance of the resource" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}")
        .to_return(body: { example: resource.attributes }.to_json)

      model = ExampleResource.find(resource.id)

      expect(model).to be_a described_class
      expect(model.attributes).to eq resource.attributes
    end
  end

  describe ".all" do
    it "returns resources" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples")
        .with(query: { page: 1, per_page: 50 })
        .to_return(body: { examples: [resource.attributes], meta: { pagination: { total_entries: 1 } } }.to_json)

      models = ExampleResource.all

      expect(models.count).to eq 1
      expect(models.first).to be_a ExampleResource
      expect(models.first.attributes).to eq resource.attributes
    end

    it "returns resources sorted by name" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples")
        .with(query: { page: 1, per_page: 50, sort: "name:desc" })
        .to_return(body: { examples: [resource.attributes.merge(id: 1, name: "aaa"), resource.attributes.merge(id: 2, name: "bbb")], meta: { pagination: { page: 1, last_page: 1, total_entries: 2 } } }.to_json)

      models = ExampleResource.all.sort(name: :desc)

      expect(models.count).to eq 2
      expect(models.map(&:id)).to eq [1, 2]
    end

    it "returns resources filtered by name" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples")
        .with(query: { page: 1, per_page: 50, name: "aaa" })
        .to_return(body: { examples: [resource.attributes.merge(id: 1, name: "aaa")], meta: { pagination: { total_entries: 1 } } }.to_json)

      models = ExampleResource.all.where(name: "aaa")

      expect(models.count).to eq 1
    end
  end
end
# frozen_string_literal: true
