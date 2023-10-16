# frozen_string_literal: true

RSpec.describe HCloud::Server, :integration, order: :defined do
  let(:file_one) { File.read(HCloud.root.join("spec/fixtures/one.pub")) }

  id_one, id_two = nil

  ssh_key_id = nil

  it "creates an SSH key" do
    ssh_key = HCloud::SSHKey.new(name: "ssh_key", public_key: file_one)
    ssh_key.create

    expect(ssh_key).to be_created

    ssh_key_id = ssh_key.id
  end

  it "creates a server" do
    server = described_class.new(name: "first", image: "debian-11", server_type: "cx11", location: "nbg1", ssh_keys: [ssh_key_id])

    server.create

    expect(server).to be_created
    expect(server.id).not_to be_nil

    id_one = server.id
  end

  it "creates another server" do
    server = described_class.new(name: "second", image: "debian-11", server_type: "cx11", location: "fsn1")

    server.create

    expect(server).to be_created
    expect(server.id).not_to be_nil

    expect(server.root_password).not_to be_nil

    id_two = server.id
  end

  it "finds a server" do
    server = described_class.find(id_one)

    expect(server.name).to eq "first"

    expect(server.server_type.name).to eq "cx11"

    expect(server.status).to eq "initializing"

    expect(server.backup_window).to be_nil
    expect(server.datacenter.location.name).to eq "nbg1"

    expect(server.included_traffic).not_to be_zero
    expect(server.ingoing_traffic).to be_nil
    expect(server.outgoing_traffic).to be_nil

    expect(server.primary_disk_size).to eq 20

    expect(server.protection).not_to be_delete
    expect(server.protection).not_to be_rebuild

    expect(server).not_to be_locked
    expect(server).not_to be_rescue_enabled

    expect(server.image.name).to eq "debian-11"

    expect(server.public_net.ipv4).not_to be_blocked
    expect(server.private_net).to be_nil

    expect(server.placement_group).to be_nil

    expect(server.iso).to be_nil

    expect(server.load_balancers).to be_empty

    expect(server.volumes).to be_empty
  end

  it "lists servers" do
    servers = described_class.all

    expect(servers.count).to eq 2
    expect(servers.map(&:id)).to contain_exactly(id_one, id_two)
  end

  it "sorts servers" do
    servers = described_class.all.sort(name: :desc)

    expect(servers.count).to eq 2
    expect(servers.map(&:id)).to eq [id_two, id_one]
  end

  it "filters servers" do
    servers = described_class.all.where(name: "first")

    expect(servers.count).to eq 1
    expect(servers.first.id).to eq id_one
  end

  it "updates a server" do
    server = described_class.find(id_one)

    server.name = "third"

    server.update

    server = described_class.find(id_one)

    expect(server.name).to eq "third"
  end

  it "deletes a server" do
    server = described_class.find(id_one)

    server.delete

    expect(server).to be_deleted

    expect { described_class.find(id_one) }.to raise_error HCloud::Errors::NotFound
  end

  it "retrieves metrics" do
    server = described_class.find(id_two)

    metrics = server.metrics(type: :cpu, from: 1.minute.ago, to: 1.second.ago)

    expect(metrics).not_to be_nil
  end
end
