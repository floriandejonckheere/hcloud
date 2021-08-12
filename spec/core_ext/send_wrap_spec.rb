# frozen_string_literal: true

RSpec.describe CoreExt::SendWrap do
  context "when subject is an object" do
    subject(:object) { "string" }

    it "sends a message to the object" do
      expect(object.send_wrap(:to_sym)).to eq :string
    end
  end

  context "when subject is an enumerable" do
    subject(:object) { ["string"] }

    it "sends a message to the objects in the enumerable" do
      expect(object.send_wrap(:to_sym)).to eq [:string]
    end
  end
end
