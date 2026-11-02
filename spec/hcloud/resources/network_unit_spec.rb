# frozen_string_literal: true

RSpec.describe HCloud::Network do
  subject(:network) { described_class.new(id: 1) }

  describe "#members" do
    let(:members) do
      [
        { type: "server", id: 42, ip: "10.0.0.2", alias_ips: ["10.0.0.3"], subnet: "10.0.0.0/24", status: "ok" },
        { type: "load_balancer", id: 43, ip: "10.0.0.4", alias_ips: [], subnet: "10.0.0.0/24", status: "attaching" },
      ]
    end

    let(:meta) { { pagination: { page: 1, per_page: 50, previous_page: nil, next_page: nil, last_page: 1, total_entries: 2 } } }

    it "lists network members" do
      stub_request(:get, "https://api.hetzner.cloud/v1/networks/1/members")
        .with(query: { page: 1, per_page: 50 })
        .to_return(body: { members: members, meta: meta }.to_json)

      expect(network.members.count).to eq 2

      server, load_balancer = network.members.to_a

      expect(server.type).to eq "server"
      expect(server.id).to eq 42
      expect(server.ip).to eq "10.0.0.2"
      expect(server.alias_ips).to eq ["10.0.0.3"]
      expect(server.subnet).to eq "10.0.0.0/24"
      expect(server.status).to eq "ok"
      expect(server.resource).to be_a HCloud::Server
      expect(server.resource.id).to eq 42

      expect(load_balancer.status).to eq "attaching"
      expect(load_balancer.resource).to be_a HCloud::LoadBalancer
      expect(load_balancer.resource.id).to eq 43
    end

    it "filters network members" do
      stub_request(:get, "https://api.hetzner.cloud/v1/networks/1/members")
        .with(query: { page: 1, per_page: 50, type: "load_balancer" })
        .to_return(body: { members: members.drop(1), meta: meta.deep_merge(pagination: { total_entries: 1 }) }.to_json)

      members = network.members.where(type: "load_balancer").to_a

      expect(members.map(&:id)).to eq [43]
    end

    it "raises when the network has no ID" do
      expect { described_class.new.members }.to raise_error HCloud::Errors::MissingIDError
    end
  end
end
