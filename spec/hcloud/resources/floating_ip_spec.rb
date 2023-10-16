# frozen_string_literal: true

RSpec.describe HCloud::FloatingIP, :integration, order: :defined do
  id_one, id_two = nil

  action_id_one = nil

  after(:all) do
    described_class.all.each { |m| m.change_protection(delete: false) }
    described_class.all.each(&:delete)
  end

  it "creates a floating IP" do
    floating_ip = described_class.new(name: "first_floating_ip", description: "First Floating IP", type: "ipv4", home_location: "fsn1")

    floating_ip.create

    expect(floating_ip).to be_created
    expect(floating_ip.id).not_to be_nil

    id_one = floating_ip.id
  end

  it "creates another floating IP" do
    floating_ip = described_class.new(name: "second_floating_ip", description: "Second Floating IP", type: "ipv4", home_location: "fsn1")

    floating_ip.create

    expect(floating_ip).to be_created
    expect(floating_ip.id).not_to be_nil

    id_two = floating_ip.id
  end

  it "finds a floating IP" do
    floating_ip = described_class.find(id_one)

    expect(floating_ip.name).to eq "first_floating_ip"
    expect(floating_ip.description).to eq "First Floating IP"

    expect(floating_ip.type).to eq "ipv4"
    expect(floating_ip.ip).not_to be_nil

    expect(floating_ip.dns_ptr).not_to be_empty
    expect(floating_ip.dns_ptr.first.dns_ptr).not_to be_blank
    expect(floating_ip.dns_ptr.first.ip).not_to be_blank

    expect(floating_ip).not_to be_blocked

    expect(floating_ip.home_location.name).to eq "fsn1"
    expect(floating_ip.protection).not_to be_delete

    expect(floating_ip.server).to be_nil
  end

  it "lists floating IPs" do
    floating_ips = described_class.all

    expect(floating_ips.count).to eq 2
    expect(floating_ips.map(&:id)).to contain_exactly(id_one, id_two)
  end

  it "sorts floating IPs" do
    floating_ips = described_class.all.sort(id: :desc)

    expect(floating_ips.count).to eq 2
    expect(floating_ips.map(&:id)).to eq [id_two, id_one]
  end

  it "filters floating IPs" do
    floating_ips = described_class.all.where(name: "first_floating_ip")

    expect(floating_ips.count).to eq 1
    expect(floating_ips.first.id).to eq id_one
  end

  it "updates a floating IP" do
    floating_ip = described_class.find(id_one)

    floating_ip.name = "other_floating_ip"

    floating_ip.update

    floating_ip = described_class.find(id_one)

    expect(floating_ip.name).to eq "other_floating_ip"
  end

  it "deletes a floating IP" do
    floating_ip = described_class.find(id_one)

    floating_ip.delete

    expect(floating_ip).to be_deleted

    expect { described_class.find(id_one) }.to raise_error HCloud::Errors::NotFound
  end

  # TODO: assign a floating IP
  xit "assigns a floating IP"

  # TODO: unassign a floating IP
  xit "unassigns a floating IP"

  it "changes reverse DNS pointer" do
    floating_ip = described_class.find(id_two)

    floating_ip.change_dns_ptr(dns_ptr: "server.example.com", ip: floating_ip.dns_ptr.first.ip)

    sleep 2

    floating_ip.reload

    expect(floating_ip.dns_ptr.first.dns_ptr).to eq "server.example.com"
  end

  it "changes protection" do
    floating_ip = described_class.find(id_two)

    floating_ip.change_protection(delete: true)

    sleep 1
    floating_ip.reload

    expect(floating_ip.protection).to be_delete
  end

  it "lists actions" do
    actions = described_class.find(id_two).actions.sort(command: :asc)

    expect(actions.count).to eq 2
    expect(actions.map(&:command)).to contain_exactly("change_dns_ptr", "change_protection")

    action_id_one = actions.first.id
  end

  it "finds action" do
    action = described_class.find(id_two).actions.find(action_id_one)

    expect(action.command).to eq "change_dns_ptr"
    expect(action.started).not_to be_nil

    sleep 1
    action.reload

    expect(action.finished).not_to be_nil
    expect(action.progress).to eq 100

    expect(action.status).to eq "success"
    expect(action.error).to be_nil
  end
end
