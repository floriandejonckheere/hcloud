# frozen_string_literal: true

RSpec.describe HCloud::LoadBalancer do
  describe "#create" do
    it "serializes public_net with primary IP IDs correctly" do
      load_balancer = described_class.new(
        name: "my-load-balancer",
        load_balancer_type: "lb11",
        location: "nbg1",
        public_net: { ipv4: 111, ipv6: 222 },
      )

      stub_request(:post, "https://api.hetzner.cloud/v1/load_balancers")
        .with(body: {
                name: "my-load-balancer",
                public_net: { ipv4: 111, ipv6: 222 },
                load_balancer_type: "lb11",
                location: "nbg1",
              })
        .to_return(body: {
          load_balancer: {
            id: 1,
            name: "my-load-balancer",
            public_net: {
              enabled: true,
              ipv4: { id: 111, ip: "1.2.3.4", blocked: false, dns_ptr: "lb.example.com" },
              ipv6: { id: 222, ip: "2001:db8::1", blocked: false, dns_ptr: "lb.example.com" },
            },
            created: 1.second.ago,
          },
        }.to_json)

      load_balancer.create

      expect(load_balancer).to be_created
      expect(load_balancer.public_net).to be_enabled
      expect(load_balancer.public_net.ipv4.id).to eq 111
      expect(load_balancer.public_net.ipv4.ip).to eq "1.2.3.4"
      expect(load_balancer.public_net.ipv4).not_to be_blocked
      expect(load_balancer.public_net.ipv6.id).to eq 222
      expect(load_balancer.public_net.ipv6.dns_ptr).to eq "lb.example.com"
    end

    it "does not serialize public_net when not set" do
      load_balancer = described_class.new(name: "my-load-balancer", load_balancer_type: "lb11", location: "nbg1")

      expect(load_balancer.creatable_params).not_to have_key("public_net")
    end
  end
end
