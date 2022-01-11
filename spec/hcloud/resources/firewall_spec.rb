# frozen_string_literal: true

RSpec.describe HCloud::Firewall, integration: true, order: :defined do
  firewall_server, firewall_label = nil

  server = nil

  it "creates a firewall applied to a label" do
    server = HCloud::Server.create(name: "first", server_type: "cx11", image: "debian-11", labels: { environment: "production" })

    firewall = described_class.create(name: "firewall_applied_to_a_label", apply_to: [{ type: "label_selector", label_selector: { selector: "environment=production" } }])

    firewall.reload

    expect(firewall).to be_created
    expect(firewall.id).not_to be_nil

    expect(firewall.applied_to.first.type).to eq "label_selector"
    expect(firewall.applied_to.first.label_selector).to eq selector: "environment=production"

    expect(firewall.applied_to.first.applied_to_resources.first.server).to eq server

    firewall_label = firewall.id
  end

  it "creates a firewall applied to a server" do
    firewall = described_class.create(name: "firewall_applied_to_a_server", apply_to: [{ type: "server", server: server }])

    firewall.reload

    expect(firewall).to be_created
    expect(firewall.id).not_to be_nil

    expect(firewall.applied_to.first.type).to eq "server"
    expect(firewall.applied_to.first.server).to eq server

    firewall_server = firewall.id
  end

  it "finds an firewall" do
    firewall = described_class.find(firewall_server)

    expect(firewall.name).to eq "firewall_applied_to_a_server"
  end

  it "lists firewalls" do
    firewalls = described_class.all

    expect(firewalls.count).to eq 2
    expect(firewalls.map(&:id)).to match_array [firewall_server, firewall_label]
  end

  it "sorts firewalls" do
    firewalls = described_class.all.sort(name: :desc)

    expect(firewalls.count).to eq 2
    expect(firewalls.map(&:id)).to eq [firewall_label, firewall_server]
  end

  it "filters firewalls" do
    firewalls = described_class.all.where(name: "firewall_applied_to_a_label")

    expect(firewalls.count).to eq 1
    expect(firewalls.first.id).to eq firewall_label
  end

  it "updates a firewall" do
    firewall = described_class.find(firewall_server)

    firewall.name = "other_firewall"

    firewall.update

    firewall = described_class.find(firewall_server)

    expect(firewall.name).to eq "other_firewall"
  end

  it "deletes a firewall" do
    server.delete

    firewall = described_class.find(firewall_server)

    firewall.delete

    expect(firewall).to be_deleted

    expect { described_class.find(firewall_server) }.to raise_error HCloud::Errors::NotFound
  end
end
