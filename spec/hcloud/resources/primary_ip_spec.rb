# frozen_string_literal: true

RSpec.describe HCloud::PrimaryIP, integration: true, order: :defined do
  id_one, id_two = nil

  action_id_one = nil

  after(:all) do
    described_class.all.each(&:delete)
  end

  it "creates a primary IP" do
    primary_ip = described_class.new(name: "first_primary_ip", type: "ipv4", datacenter: "fsn1-dc14")

    primary_ip.create

    expect(primary_ip).to be_created
    expect(primary_ip.id).not_to be_nil

    id_one = primary_ip.id
  end

  it "creates another primary IP" do
    primary_ip = described_class.new(name: "second_primary_ip", type: "ipv4", datacenter: "fsn1-dc14")

    primary_ip.create

    expect(primary_ip).to be_created
    expect(primary_ip.id).not_to be_nil

    id_two = primary_ip.id
  end

  it "finds a primary IP" do
    primary_ip = described_class.find(id_one)

    expect(primary_ip.name).to eq "first_primary_ip"

    expect(primary_ip.type).to eq "ipv4"
    expect(primary_ip.ip).not_to be_nil

    expect(primary_ip.assignee_id).to be_blank
    expect(primary_ip.assignee_type).to eq "server"

    expect(primary_ip.dns_ptr).not_to be_empty
    expect(primary_ip.dns_ptr.first.dns_ptr).not_to be_blank
    expect(primary_ip.dns_ptr.first.ip).not_to be_blank

    expect(primary_ip.datacenter.name).to eq "fsn1-dc14"

    expect(primary_ip.protection).not_to be_delete
  end

  it "lists primary IPs" do
    primary_ips = described_class.all

    expect(primary_ips.count).to eq 2
    expect(primary_ips.map(&:id)).to match_array [id_one, id_two]
  end

  it "sorts primary IPs" do
    primary_ips = described_class.all.sort(id: :desc)

    expect(primary_ips.count).to eq 2
    expect(primary_ips.map(&:id)).to eq [id_two, id_one]
  end

  it "filters primary IPs" do
    primary_ips = described_class.all.where(name: "first_primary_ip")

    expect(primary_ips.count).to eq 1
    expect(primary_ips.first.id).to eq id_one
  end

  it "updates a primary IP" do
    primary_ip = described_class.find(id_one)

    primary_ip.name = "other_primary_ip"

    primary_ip.update

    primary_ip = described_class.find(id_one)

    expect(primary_ip.name).to eq "other_primary_ip"
  end

  it "deletes a primary IP" do
    primary_ip = described_class.find(id_one)

    primary_ip.delete

    expect(primary_ip).to be_deleted

    expect { described_class.find(id_one) }.to raise_error HCloud::Errors::NotFound
  end
end
