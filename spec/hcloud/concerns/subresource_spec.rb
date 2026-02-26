# frozen_string_literal: true

RSpec.describe HCloud::Subresource do
  subject(:resource) { ExampleResource.new(id: 1) }

  let(:subresource) { SubexampleResource.new(example: 1, id: 2) }

  describe "resource" do
    describe "#subresource_names" do
      it "lists all subresource names" do
        expect(resource.subresource_names).to contain_exactly "subexamples"
      end
    end

    describe "#resource_class" do
      it "returns nil" do
        expect(resource.resource_class).to be_nil
      end
    end

    describe "#subexamples" do
      it "raises when no id was present" do
        resource.id = nil

        expect { resource.subexamples }.to raise_error HCloud::Errors::MissingIDError
      end

      it "returns a collection of subresources" do
        stub_request(:get, "https://api.hetzner.cloud/v1/examples/#{resource.id}/subexamples")
          .to_return(body: { subexamples: [id: 2, name: "subexample"] }.to_json)

        subresources = resource.subexamples

        expect(subresources).to be_a HCloud::SubCollection

        expect(subresources.count).to eq 1

        expect(subresources.first).to be_a SubexampleResource
        expect(subresources.first.id).to eq 2
        expect(subresources.first.name).to eq "subexample"
      end
    end

    describe "#resource_path" do
      it "returns the resource path" do
        expect(resource.resource_path).to eq "/examples"
      end

      it "returns the resource path when no id is present" do
        resource.id = nil

        expect(resource.resource_path).to eq "/examples"
      end
    end
  end

  describe "subresource" do
    describe "#resource_class" do
      it "returns the resource class" do
        expect(subresource.resource_class).to eq resource.class
      end
    end

    describe "#example" do
      it "returns the resource ID" do
        expect(subresource.example).to eq 1
      end
    end

    describe "#resource_path" do
      it "returns the resource path" do
        expect(subresource.resource_path).to eq "/examples/#{resource.id}/subexamples"
      end

      it "returns the resource path when no resource id is present" do
        subresource.example = nil

        expect(subresource.resource_path).to eq "/subexamples"
      end
    end

    describe ".resource_path" do
      it "returns the resource path" do
        expect(subresource.resource_path).to eq "/examples/#{resource.id}/subexamples"
      end
    end

    context "when subresource has a defined resource type" do
      let(:subresource) do
        Class.new(HCloud::Resource) do
          subresource_of :example, :example_resource

          attribute :id, :integer
          attribute :example, :example_resource

          # Override resource name
          def self.resource_name
            "subexample"
          end
        end.new(example: 1)
      end

      it "returns the resource path" do
        expect(subresource.resource_path).to eq "/examples/1/subexamples"
        expect(subresource.resource_path(id: "2")).to eq "/examples/1/subexamples/2"
      end
    end

    context "when subresource is defined as a simple type" do
      let(:subresource) do
        Class.new(HCloud::Resource) do
          subresource_of :example, :example_resource

          attribute :id, :integer
          attribute :example, :string

          # Override resource name
          def self.resource_name
            "subexample"
          end
        end.new(example: "simple")
      end

      it "returns the resource path" do
        expect(subresource.resource_path).to eq "/examples/simple/subexamples"
        expect(subresource.resource_path(id: "2")).to eq "/examples/simple/subexamples/2"
      end
    end
  end
end
