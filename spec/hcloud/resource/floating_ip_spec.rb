# frozen_string_literal: true

RSpec.describe HCloud::FloatingIP, integration: true, order: :defined do
  id_one, id_two = nil

  after(:all) { described_class.all.each(&:delete) }

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
    expect(floating_ips.map(&:id)).to match_array [id_one, id_two]
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
end
