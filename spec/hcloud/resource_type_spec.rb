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

  it "casts array to array of resource class" do
    expect(example_type.cast([1, 2])).to eq [ExampleResource.new(id: 1), ExampleResource.new(id: 2)]
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
        expect { ActiveModel::Type.lookup subclass.name.demodulize.underscore.to_sym }.not_to raise_error
      end
    end
  end
end
