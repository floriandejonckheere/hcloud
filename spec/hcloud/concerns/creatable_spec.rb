# frozen_string_literal: true

RSpec.describe HCloud::Creatable do
  subject(:resource) { ExampleResource.new }

  describe "#create" do
    subject(:resource) { ExampleResource.new(id: nil, name: "my_resource", description: "my_description", created: nil, sibling: sibling, child: child1, children: [child0, child1]) }

    let(:child0) { Child.new(id: 1) }
    let(:child1) { Child.new(name: "name1") }

    let(:sibling) { Sibling.new(name: "sibling", child: child0) }

    it "creates the resource" do
      stub_request(:post, "https://api.hetzner.cloud/v1/examples")
        .with(body: { name: "my_resource", description: "my_description", sibling: { name: "sibling", child: { id: 1 } }, child: "name1", children: [1, nil] })
        .to_return(body: { example: resource.attributes.merge(id: 1, created: 1.second.ago) }.to_json)
      resource.create

      expect(resource.id).to eq 1
      expect(resource).to be_created
    end
  end

  describe ".create" do
    it "creates the resource" do
      stub_request(:post, "https://api.hetzner.cloud/v1/examples")
        .with(body: { name: "my_resource", description: "my_description" })
        .to_return(body: { example: resource.attributes.merge(id: 1, created: 1.second.ago) }.to_json)

      resource = ExampleResource.create(name: "my_resource", description: "my_description")

      expect(resource.id).to eq 1
      expect(resource).to be_created
    end
  end
end
