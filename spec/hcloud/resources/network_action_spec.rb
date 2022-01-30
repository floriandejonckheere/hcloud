# frozen_string_literal: true

RSpec.describe HCloud::Network, integration: true, order: :defined do
  network = nil

  before(:all) do
    network = described_class.create(name: "network", ip_range: "10.0.0.0/16")
  end

  it "changes protection" do
    network.change_protection(delete: true)

    network.reload

    expect(network.protection).to be_delete

    network.change_protection(delete: false)
  end

  it "lists actions" do
    expect(network.actions.count).to eq 2
    expect(network.actions.map(&:command)).to eq ["change_protection", "change_protection"]
  end

  it "finds action" do
    action_id = network.actions.first.id

    action = network.actions.find(action_id)

    expect(action.command).to eq "change_protection"
    expect(action.started).not_to be_nil
  end

  it "adds a route" do
    network.add_route(destination: "10.100.1.0/24", gateway: "10.0.1.1")

    network.reload

    expect(network.routes.count).to eq 1
    expect(network.routes.first.destination).to eq "10.100.1.0/24"
    expect(network.routes.first.gateway).to eq "10.0.1.1"
  end

  it "adds a subnet" do
    network.add_subnet(ip_range: "10.0.1.0/24", network_zone: "eu-central", type: "cloud")

    network.reload

    expect(network.subnets.count).to eq 1
    expect(network.subnets.first.type).to eq "cloud"
    expect(network.subnets.first.ip_range).to eq "10.0.1.0/24"
    expect(network.subnets.first.network_zone).to eq "eu-central"
  end

  it "changes the IP range" do
    network.change_ip_range(ip_range: "10.0.0.0/15")

    network.reload

    expect(network.ip_range).to eq "10.0.0.0/15"
  end

  it "deletes a route" do
    network.delete_route(destination: "10.100.1.0/24", gateway: "10.0.1.1")

    network.reload

    expect(network.routes).to be_empty
  end

  it "deletes a subnet" do
    network.delete_subnet(ip_range: "10.0.1.0/24", network_zone: "eu-central", type: "cloud")

    network.reload

    expect(network.subnets).to be_empty
  end
end
