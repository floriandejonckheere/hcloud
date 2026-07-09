# frozen_string_literal: true

RSpec.describe HCloud::Server do
  subject(:server) { described_class.new(name: "my-server") }

  describe "#create" do
    it "serializes public_net and ssh_keys correctly" do
      # Set up server with public_net and ssh_keys
      server = described_class.new(
        name: "my-server",
        image: "debian-11",
        server_type: "cx11",
        public_net: {
          enable_ipv4: false,
          enable_ipv6: false,
        },
        ssh_keys: [
          HCloud::SSHKey.new(name: "my-key-name"),
          HCloud::SSHKey.new(id: 12_345),
          HCloud::SSHKey.new(id: 67_890, name: "both"),
        ],
      )

      # Stub the POST request and assert the body contains correct values
      stub_request(:post, "https://api.hetzner.cloud/v1/servers")
        .with(body: {
                name: "my-server",
                image: "debian-11",
                server_type: "cx11",
                public_net: {
                  enable_ipv4: false,
                  enable_ipv6: false,
                },
                ssh_keys: ["my-key-name", 12_345, 67_890],
              })
        .to_return(body: { server: server.attributes.merge(id: 1, created: 1.second.ago) }.to_json)

      server.create

      expect(server).to be_created
      expect(server.id).to eq 1
    end

    it "serializes public_net with primary IP IDs correctly" do
      # Set up server with public_net including primary IP IDs
      server = described_class.new(
        name: "my-server",
        image: "debian-11",
        server_type: "cx11",
        public_net: {
          enable_ipv4: true,
          enable_ipv6: true,
          ipv4: HCloud::IPv4.new(id: 111),
          ipv6: HCloud::IPv6.new(id: 222),
        },
      )

      stub_request(:post, "https://api.hetzner.cloud/v1/servers")
        .with(body: {
                name: "my-server",
                image: "debian-11",
                server_type: "cx11",
                public_net: {
                  enable_ipv4: true,
                  enable_ipv6: true,
                  ipv4: 111,
                  ipv6: 222,
                },
              })
        .to_return(body: { server: server.attributes.merge(id: 1, created: 1.second.ago) }.to_json)

      server.create

      expect(server).to be_created
    end
  end
end
