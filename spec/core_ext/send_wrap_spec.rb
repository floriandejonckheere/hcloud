# frozen_string_literal: true

RSpec.describe CoreExt::SendWrap do
  context "when subject is an object" do
    subject(:object) { "string" }

    it "sends a message to the object" do
      expect(object.send_wrap(:to_sym)).to eq :string
    end

    it "sends a message and arguments to the object" do
      expect(object.send_wrap(:try, :to_sym)).to eq :string
    end
  end

  context "when subject is an enumerable" do
    subject(:object) { ["string"] }

    it "sends a message to the objects in the enumerable" do
      expect(object.send_wrap(:to_sym)).to eq [:string]
    end

    it "sends a message and arguments to the objects" do
      expect(object.send_wrap(:try, :to_sym)).to eq [:string]
    end
  end

  context "when subject is a hash" do
    subject(:object) { { foo: "bar" } }

    it "sends a message to the objects in the hash" do
      expect(object.send_wrap(:to_sym)).to eq({ foo: :bar })
    end

    it "sends a message and arguments to the objects" do
      expect(object.send_wrap(:try, :to_sym)).to eq({ foo: :bar })
    end
  end
end
