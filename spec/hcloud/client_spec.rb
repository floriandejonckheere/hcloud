# frozen_string_literal: true

RSpec.describe HCloud::Client do
  subject(:client) { described_class.new(access_token: "access_token") }

  it "has an access_token" do
    expect(client.access_token).to eq "access_token"
  end

  it "has a default endpoint" do
    expect(client.endpoint).to eq "https://api.hetzner.cloud/v1"
  end

  it "has a default storage box endpoint" do
    expect(client.storage_box_endpoint).to eq "https://api.hetzner.com/v1"
  end

  describe "#storage_box_client" do
    it "returns a new client with the storage box endpoint" do
      storage_box_client = client.storage_box_client

      expect(storage_box_client).to be_a described_class
      expect(storage_box_client.endpoint).to eq "https://api.hetzner.com/v1"
      expect(storage_box_client.access_token).to eq "access_token"
      expect(storage_box_client.logger).to eq client.logger
      expect(storage_box_client.rate_limit).to eq client.rate_limit
      expect(storage_box_client.timeout).to eq client.timeout
      expect(storage_box_client.compression).to eq client.compression
    end
  end

  describe ".connection" do
    it "raises when no client has been configured" do
      expect { described_class.connection.get }.to raise_error ArgumentError
    end
  end
end
