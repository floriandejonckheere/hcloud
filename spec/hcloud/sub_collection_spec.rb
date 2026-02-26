# frozen_string_literal: true

RSpec.describe HCloud::SubCollection do
  subject(:subcollection) { described_class.new(:subexample, :subexample_resource, resource) }

  let(:resource) { ExampleResource.new(id: 1) }

  describe "#find" do
    it "raises when no id was present" do
      resource.id = nil

      expect { subcollection.find(2) }.to raise_error HCloud::Errors::MissingIDError
    end

    it "finds a subresource" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/subexamples/2")
        .to_return(body: { subexample: { id: 2, name: "subexample", example: resource.id } }.to_json)

      subresource = subcollection.find(2)

      expect(subresource.id).to eq 2
      expect(subresource.name).to eq "subexample"
      expect(subresource.example).to eq resource.id
    end
  end

  describe "#where" do
    it "returns a collection of subresources" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/subexamples?label_selector=foo%3Dbar")
        .to_return(body: { subexamples: [id: 2, name: "subexample"] }.to_json)

      subresources = subcollection.where(label_selector: "foo=bar")

      expect(subresources).to be_a described_class
      expect(subresources.count).to eq 1
      expect(subresources.first.id).to eq 2
      expect(subresources.first.name).to eq "subexample"
    end
  end

  describe "#new" do
    it "initializes a new subresource" do
      new_subresource = subcollection.new(name: "new subexample")

      expect(new_subresource).to be_a SubexampleResource
      expect(new_subresource.name).to eq "new subexample"
      expect(new_subresource.example).to eq resource.id
    end
  end

  describe "#create" do
    it "creates a subresource" do
      stub_request(:post, "https://api.hetzner.cloud/v1/examples/#{resource.id}/subexamples")
        .with(body: { name: "new subexample" })
        .to_return(body: { subexample: { id: 3, name: "new subexample" } }.to_json)

      new_subresource = subcollection.create(name: "new subexample")

      expect(new_subresource.id).to eq 3
      expect(new_subresource.name).to eq "new subexample"
      expect(new_subresource.example).to eq resource.id
    end
  end

  describe "#count" do
    it "returns the number of subresources" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/subexamples")
        .to_return(body: { subexamples: [{ id: 1 }, { id: 2 }, { id: 3 }] }.to_json)

      expect(subcollection.count).to eq 3
    end
  end

  describe "#empty?" do
    it "returns false" do
      stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/subexamples")
        .to_return(body: { subexamples: [{ id: 1 }, { id: 2 }, { id: 3 }] }.to_json)

      expect(subcollection).not_to be_empty
    end
  end
end
