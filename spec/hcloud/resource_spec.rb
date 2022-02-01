# frozen_string_literal: true

RSpec.describe HCloud::Resource do
  subject(:resource) { resource_class.new }

  include_context "resource"

  it "has default labels" do
    expect(resource_class.new.labels).to eq({})
  end

  describe "#to_h" do
    it "serializes the identifier" do
      expect(resource.to_h).to eq({ id: resource.id })
    end
  end

  describe "#==" do
    it "is not equal when no id exists" do
      expect(resource_class.new(id: nil)).not_to eq resource_class.new(id: nil)
    end

    it "is not equal when id does not match" do
      expect(resource_class.new(id: 123)).not_to eq resource_class.new(id: 321)
    end

    it "is equal when id matches" do
      # rubocop:disable RSpec/IdenticalEqualityAssertion
      expect(resource_class.new(id: 123)).to eq resource_class.new(id: 123)
      # rubocop:enable RSpec/IdenticalEqualityAssertion
    end
  end
end
