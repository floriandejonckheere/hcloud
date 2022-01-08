# frozen_string_literal: true

RSpec.describe HCloud::ResourceType do
  subject(:resource_type) { described_class.new.tap { |k| k.resource_class_name = "OpenStruct" } }

  it "casts nil to nil" do
    expect(resource_type.cast(nil)).to eq nil
  end

  it "casts empty array to nil" do
    expect(resource_type.cast([])).to eq nil
  end

  it "casts resource class to resource class" do
    expect(resource_type.cast(OpenStruct.new(id: 3))).to eq OpenStruct.new(id: 3)
  end

  it "casts integer to resource class" do
    expect(resource_type.cast(3)).to eq OpenStruct.new(id: 3)
  end

  it "casts string to resource class" do
    expect(resource_type.cast("my_name")).to eq OpenStruct.new(name: "my_name")
  end

  it "casts hash to resource class" do
    expect(resource_type.cast({ id: 3, name: "my_name" })).to eq OpenStruct.new(id: 3, name: "my_name")
  end

  it "casts array to array of resource class" do
    expect(resource_type.cast([1, 2])).to eq [OpenStruct.new(id: 1), OpenStruct.new(id: 2)]
  end

  it "does not cast different classes" do
    expect { resource_type.cast(Set.new) }.to raise_error ArgumentError
  end

  context "when resource is an array type" do
    subject(:resource_type) { described_class.new(array: true).tap { |k| k.resource_class_name = "OpenStruct" } }

    it "casts nil to an empty array" do
      expect(resource_type.cast(nil)).to eq []
    end

    it "casts empty array to an empty array" do
      expect(resource_type.cast([])).to eq []
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
