# frozen_string_literal: true

RSpec.describe HCloud::Network, :integration, order: :defined do
  id = nil

  it "creates a network" do
    route = { destination: "10.100.1.0/24", gateway: "10.0.1.1" }
    subnet = { ip_range: "10.0.1.0/24", network_zone: "eu-central", type: "cloud" }
    network = described_class.create(name: "network", ip_range: "10.0.0.0/16", routes: [route], subnets: [subnet])

    network.reload

    expect(network).to be_created
    expect(network.id).not_to be_nil

    expect(network.ip_range).to eq "10.0.0.0/16"

    expect(network).not to be_expose_routes_to_vswitch

    expect(network.subnets.first.type).to eq "cloud"
    expect(network.subnets.first.ip_range).to eq "10.0.1.0/24"
    expect(network.subnets.first.network_zone).to eq "eu-central"

    expect(network.routes.first.destination).to eq "10.100.1.0/24"
    expect(network.routes.first.gateway).to eq "10.0.1.1"

    id = network.id
  end

  it "finds an network" do
    network = described_class.find(id)

    expect(network.name).to eq "network"
  end

  it "lists networks" do
    networks = described_class.all

    expect(networks.count).to eq 1
    expect(networks.first.id).to eq id
  end

  it "filters networks" do
    networks = described_class.all.where(name: "notwork")

    expect(networks).to be_empty
  end

  it "updates a network" do
    network = described_class.find(id)

    network.name = "other_network"

    network.update

    network = described_class.find(id)

    expect(network.name).to eq "other_network"
  end

  it "deletes a network" do
    network = described_class.find(id)

    network.delete

    expect(network).to be_deleted

    expect { described_class.find(id) }.to raise_error HCloud::Errors::NotFound
  end
end
