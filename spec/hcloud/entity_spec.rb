# frozen_string_literal: true

class Child < HCloud::Resource
  attribute :id, :integer
  attribute :name
end

ActiveModel::Type.register(:child, HCloud::ResourceType.Type("Child"))

RSpec.describe HCloud::Entity do
  subject(:entity) { entity_class.new(type: "child", child: child) }

  let(:child) { Child.new(id: 1, name: "child") }

  let(:entity_class) do
    Class.new(described_class) do
      attribute :type, default: "parent"
      attribute :child, :child
    end
  end

  it "has default attributes" do
    expect(entity_class.new.attributes.symbolize_keys).to include(type: "parent")
  end

  describe "#to_h" do
    it "serializes the attributes" do
      expect(entity.to_h.symbolize_keys).to include(type: "child", child: { id: 1 })
    end

    it "omits empty attributes" do
      entity.child = nil

      expect(entity.to_h.symbolize_keys).not_to include(:child)
    end
  end
end
