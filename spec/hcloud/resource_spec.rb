# frozen_string_literal: true

RSpec.describe HCloud::Resource do
  subject(:resource) { ExampleResource.new }

  it "has default labels" do
    expect(ExampleResource.new.labels).to eq({})
  end

  it "allows dynamic attributes" do
    resource.foo = "bar"

    expect(resource.foo).to eq "bar"
  end

  describe "#to_h" do
    it "serializes the identifier" do
      expect(resource.to_h).to eq({ id: resource.id })
    end
  end

  describe "#==" do
    it "is not equal when no id exists" do
      expect(ExampleResource.new(id: nil)).not_to eq ExampleResource.new(id: nil)
    end

    it "is not equal when id does not match" do
      expect(ExampleResource.new(id: 123)).not_to eq ExampleResource.new(id: 321)
    end

    it "is equal when id matches" do
      # rubocop:disable RSpec/IdenticalEqualityAssertion
      expect(ExampleResource.new(id: 123)).to eq ExampleResource.new(id: 123)
      # rubocop:enable RSpec/IdenticalEqualityAssertion
    end
  end
end
