# frozen_string_literal: true

RSpec.describe HCloud::Creatable do
  subject(:resource) { ExampleResource.new }

  describe "#create" do
    subject(:resource) { ExampleResource.new(id: nil, name: "my_resource", description: "my_description", created: nil, sibling: sibling, child: second_child, children: [first_child, second_child]) }

    let(:first_child) { Child.new(id: 1) }
    let(:second_child) { Child.new(name: "name1") }

    let(:sibling) { Sibling.new(type: "sister", child: first_child) }

    it "creates the resource" do
      stub_request(:post, "https://api.hetzner.cloud/v1/examples")
        .with(body: { name: "my_resource", description: "my_description", sibling: { type: "sister", child: { id: 1 } }, child: "name1", children: [1, nil] })
        .to_return(body: { example: resource.attributes.merge(id: 1, created: 1.second.ago) }.to_json)

      resource.create

      expect(resource.id).to eq 1
      expect(resource).to be_created
    end

    it "returns the resource" do
      stub_request(:post, "https://api.hetzner.cloud/v1/examples")
        .with(body: { name: "my_resource", description: "my_description", sibling: { type: "sister", child: { id: 1 } }, child: "name1", children: [1, nil] })
        .to_return(body: { example: resource.attributes.merge(id: 1, created: 1.second.ago) }.to_json)

      expect(resource.create).to be_a described_class
    end

    context "when the API return an action" do
      it "returns the action" do
        stub_request(:post, "https://api.hetzner.cloud/v1/examples")
          .with(body: { name: "my_resource", description: "my_description", sibling: { type: "sister", child: { id: 1 } }, child: "name1", children: [1, nil] })
          .to_return(body: { action: { id: 1, status: "running", command: "create_resource", resources: [{ id: 2, type: "example" }] } }.to_json)

        action = resource.create

        expect(action).to be_a HCloud::Action

        expect(action.id).to eq 1
        expect(action.status).to eq "running"
        expect(action.command).to eq "create_resource"

        expect(resource.id).to eq 2
      end
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
