# frozen_string_literal: true

RSpec.describe HCloud::Errors::Error do
  subject(:error) { described_class.new }

  describe ".from_h" do
    it "creates an error from only the message" do
      data = {
        code: "uniqueness_error",
        message: "SSH key with the same fingerprint already exists",
        details: {},
      }

      error = described_class.new(data)

      expect(error.message).to include "SSH key with the same fingerprint already exists"
      expect(error.full_messages).to be_nil
    end

    it "creates an error from simple data" do
      data = {
        code: "uniqueness_error",
        message: "SSH key with the same fingerprint already exists",
        details: {
          fields: [
            {
              name: "public_key",
            },
          ],
        },
      }

      error = described_class.new(data)

      expect(error.message).to include "SSH key with the same fingerprint already exists"
      expect(error.full_messages).to include "public_key SSH key with the same fingerprint already exists"
    end

    it "creates an error from detailed data" do
      data = {
        code: "invalid_input",
        message: "invalid input in field 'broken_field': is too long",
        details: {
          fields: [
            {
              name: "broken_field",
              messages: ["is too long"],
            },
          ],
        },
      }

      error = described_class.new(data)

      expect(error.message).to include "invalid input in field 'broken_field': is too long"
      expect(error.full_messages).to include "broken_field is too long"
    end

    it "creates an error from multiple details" do
      data = {
        code: "invalid_input",
        message: "invalid input in field 'broken_field': is too long",
        details: {
          fields: [
            {
              name: "broken_field",
              messages: ["is too long", "is invalid"],
            },
          ],
        },
      }

      error = described_class.new(data)

      expect(error.message).to include "invalid input in field 'broken_field': is too long"
      expect(error.full_messages).to include(
        "broken_field is too long",
        "broken_field is invalid",
      )
    end

    it "creates an error from multiple fields" do
      data = {
        message: "invalid input in fields 'name', 'server_type', 'source_server', 'image'",
        code: "invalid_input",
        details: {
          fields: [
            { name: "name", messages: ["Missing data for required field."] },
            { name: "server_type", messages: ["Missing data for required field."] },
            { name: "source_server", messages: ["source_server and image are mutually exclusive."] },
            { name: "image", messages: ["source_server and image are mutually exclusive."] },
          ],
        },
      }

      error = described_class.new(data)

      expect(error.message).to include "invalid input in fields 'name', 'server_type', 'source_server', 'image'"
      expect(error.full_messages).to include(
        "name Missing data for required field.",
        "server_type Missing data for required field.",
        "source_server source_server and image are mutually exclusive.",
        "image source_server and image are mutually exclusive.",
      )
    end
  end
end
