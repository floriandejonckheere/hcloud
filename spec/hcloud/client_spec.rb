# frozen_string_literal: true

RSpec.describe HCloud::Client do
  subject(:client) { described_class.new(access_token: "access_token") }

  it "has an access_token" do
    expect(client.access_token).to eq "access_token"
  end

  it "has a default endpoint" do
    expect(client.endpoint).to eq "https://api.hetzner.cloud/v1"
  end

  describe ".connection" do
    it "raises when no client has been configured" do
      expect { described_class.connection.get }.to raise_error ArgumentError
    end
  end
end
