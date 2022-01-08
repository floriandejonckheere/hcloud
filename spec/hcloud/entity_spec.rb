# frozen_string_literal: true

RSpec.describe HCloud::Entity do
  subject(:entity) { described_class.new }

  it "has default attributes" do
    expect(described_class.new.attributes).to eq({})
  end
end
