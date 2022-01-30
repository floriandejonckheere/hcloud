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

    it "yields the object to the block" do
      expect(object.send_wrap { |o| o.try(:to_h) || o }).to eq "string"
    end
  end

  context "when subject is an array" do
    subject(:object) { ["string"] }

    it "sends a message to the objects in the enumerable" do
      expect(object.send_wrap(:to_sym)).to eq [:string]
    end

    it "sends a message and arguments to the objects" do
      expect(object.send_wrap(:try, :to_sym)).to eq [:string]
    end

    it "yields the objects in the enumerable to the block" do
      expect(object.send_wrap { |o| o.try(:to_h) || o }).to eq ["string"]
    end
  end

  context "when subject is a hash" do
    subject(:object) { { foo: "bar" } }

    it "sends a message to the object" do
      expect(object.send_wrap(:to_s)).to eq "{:foo=>\"bar\"}"
    end

    it "does not send a message to the objects in the hash" do
      expect { object.send_wrap(:to_sym) }.to raise_error NoMethodError
    end

    it "does not send a message and arguments to the objects" do
      expect(object.send_wrap(:try, :to_sym)).to be_nil
    end

    it "yields the object to the block" do
      expect(object.send_wrap { |o| o.try(:to_h) || o }).to eq({ foo: "bar" })
    end
  end
end
