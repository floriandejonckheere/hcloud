# frozen_string_literal: true

RSpec.describe HCloud::ResourceType do
  let(:example_type) { ActiveModel::Type.lookup(:example_resource) }
  let(:sibling_type) { ActiveModel::Type.lookup(:sibling) }

  it "casts nil to nil" do
    expect(example_type.cast(nil)).to be_nil
  end

  it "casts empty array to nil" do
    expect(example_type.cast([])).to be_nil
  end

  it "casts resource class to resource class" do
    expect(example_type.cast(ExampleResource.new(id: 3))).to eq ExampleResource.new(id: 3)
  end

  it "casts integer to resource class" do
    expect(example_type.cast(3)).to eq ExampleResource.new(id: 3)
  end

  it "casts string to resource class" do
    # We need to compare attributes here, because the default equality matcher will return false when no ID is present
    expect(example_type.cast("my_name").attributes).to eq ExampleResource.new(name: "my_name").attributes
    expect(sibling_type.cast("my_type").attributes).to eq Sibling.new(type: "my_type").attributes
  end

  it "casts hash to resource class" do
    expect(example_type.cast({ id: 3, name: "my_name" })).to eq ExampleResource.new(id: 3, name: "my_name")
  end

  it "does not cast array" do
    expect { example_type.cast([1, 2]) }.to raise_error ArgumentError
  end

  it "does not cast different classes" do
    expect { example_type.cast(Set.new) }.to raise_error ArgumentError
  end

  context "when resource is an array type" do
    subject(:example_type) { described_class.new(array: true).tap { |k| k.resource_class_name = "ExampleResource" } }

    it "casts nil to an empty array" do
      expect(example_type.cast(nil)).to eq []
    end

    it "casts empty array to an empty array" do
      expect(example_type.cast([])).to eq []
    end
  end

  describe "a type registration exists for every resource" do
    HCloud::Resource.subclasses.each do |subclass|
      it "has a type registration for #{subclass}" do
        expect { ActiveModel::Type.lookup HCloud.loader.inflector.underscore(subclass.name.demodulize).to_sym }.not_to raise_error
      end
    end
  end

  describe "generic type" do
    let(:resource_type) { ActiveModel::Type.lookup(:resource) }

    it "casts nil to nil" do
      expect(resource_type.cast(nil)).to be_nil
    end

    it "casts empty array to nil" do
      expect(resource_type.cast([])).to be_nil
    end

    it "casts resource class to resource class" do
      expect(resource_type.cast(ExampleResource.new(id: 3))).to eq ExampleResource.new(id: 3)
    end

    it "does not cast integer" do
      expect { resource_type.cast(3) }.to raise_error ArgumentError
    end

    it "does not cast string" do
      expect { resource_type.cast("my_name") }.to raise_error ArgumentError
    end

    it "casts hash with id and type to resource class" do
      expect(resource_type.cast({ id: 3, type: "example_resource" })).to eq ExampleResource.new(id: 3, name: "my_name")
    end

    it "does not cast hash with id and unknown type" do
      expect { resource_type.cast({ id: 3, type: "unknown" }) }.to raise_error ArgumentError
    end

    it "does not cast hash" do
      expect { resource_type.cast({ id: 3 }) }.to raise_error ArgumentError
    end

    it "does not cast array of hash with id and type" do
      expect { resource_type.cast([{ id: 1, type: "example_resource" }, { id: 2, type: "example_resource" }]) }.to raise_error ArgumentError
    end

    it "does not cast array of hash" do
      expect { resource_type.cast([{ id: 1 }, { id: 2 }]) }.to raise_error ArgumentError
    end

    it "does not cast different classes" do
      expect { resource_type.cast(Set.new) }.to raise_error ArgumentError
    end

    context "when resource is an array type" do
      subject(:resource_type) { ActiveModel::Type.lookup(:resource).class.new(array: true) }

      it "casts nil to an empty array" do
        expect(resource_type.cast(nil)).to eq []
      end

      it "casts empty array to an empty array" do
        expect(resource_type.cast([])).to eq []
      end
    end
  end
end
