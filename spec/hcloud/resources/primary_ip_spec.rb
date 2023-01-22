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

  describe "actions" do
    # TODO: assign a primary IP
    xit "assigns a primary IP"

    # TODO: unassign a primary IP
    xit "unassigns a primary IP"

    it "changes reverse DNS pointer" do
      primary_ip = described_class.find(id_two)

      primary_ip.change_dns_ptr(dns_ptr: "server.example.com", ip: primary_ip.dns_ptr.first.ip)

      sleep 2

      primary_ip.reload

      expect(primary_ip.dns_ptr.first.dns_ptr).to eq "server.example.com"
    end

    it "changes protection" do
      primary_ip = described_class.find(id_two)

      primary_ip.change_protection(delete: true)

      sleep 1
      primary_ip.reload

      expect(primary_ip.protection).to be_delete
    end

    it "lists actions" do
      actions = described_class.find(id_two).actions.sort(command: :asc)

      expect(actions.count).to eq 2
      expect(actions.map(&:command)).to match_array(["change_dns_ptr", "change_protection"])

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
end
