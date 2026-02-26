# frozen_string_literal: true

RSpec.describe HCloud::Firewall, :integration, order: :defined do
  firewall, server = nil

  before(:all) do
    firewall = described_class.create(name: "firewall")
    server = HCloud::Server.create(name: "server", image: "debian-11", server_type: "cx11", location: "nbg1")
  end

  it "lists actions" do
    expect(firewall.actions.count).to eq 1
    expect(firewall.actions.map(&:command)).to eq ["set_firewall_rules"]
  end

  it "finds action" do
    action_id = firewall.actions.first.id

    action = firewall.actions.find(action_id)

    expect(action.command).to eq "set_firewall_rules"
    expect(action.started).not_to be_nil
  end

  it "applies to resources" do
    firewall.apply_to_resources(apply_to: [type: "server", server: { id: server.id }])

    sleep 1
    firewall.reload

    expect(firewall.applied_to.first.type).to eq "server"
    expect(firewall.applied_to.first.server).to eq server
  end

  it "sets rules" do
    firewall.set_rules(rules: [direction: "in", protocol: "tcp", port: "22", source_ips: ["0.0.0.0/0"]])

    sleep 1
    firewall.reload

    expect(firewall.rules.first.direction).to eq "in"
    expect(firewall.rules.first.protocol).to eq "tcp"
    expect(firewall.rules.first.port).to eq "22"
    expect(firewall.rules.first.source_ips).to include "0.0.0.0/0"
  end

  it "removes from resources" do
    firewall.remove_from_resources(remove_from: [type: "server", server: { id: server.id }])

    sleep 1
    firewall.reload

    expect(firewall.applied_to).to be_empty
  end
end
