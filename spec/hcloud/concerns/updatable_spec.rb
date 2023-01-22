# frozen_string_literal: true

RSpec.describe HCloud::Updatable do
  subject(:resource) { ExampleResource.new(id: 1) }

  describe "#update" do
    it "raises when no id was present" do
      resource.id = nil

      expect { resource.update }.to raise_error HCloud::Errors::MissingIDError
    end

    it "updates the resource" do
      stub_request(:put, "https://api.hetzner.cloud/v1/examples/#{resource.id}")
        .with(body: resource.attributes.slice(*resource.updatable_attributes.map(&:to_s)))
        .to_return(body: { example: resource.attributes.merge(name: "my_name") }.to_json)

      resource.update

      expect(resource.name).to eq "my_name"
    end

    it "updates the resource with the given attributes" do
      stub_request(:put, "https://api.hetzner.cloud/v1/examples/#{resource.id}")
        .with(body: resource.attributes.slice(*resource.updatable_attributes.map(&:to_s)).merge("name" => "MY_NAME"))
        .to_return(body: { example: resource.attributes.merge(name: "my_name") }.to_json)

      resource.update(name: "MY_NAME")

      expect(resource.name).to eq "my_name"
    end
  end
end
