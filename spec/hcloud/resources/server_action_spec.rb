# frozen_string_literal: true

RSpec.describe HCloud::Server, integration: true, order: :defined do
  server, placement_group = nil

  before(:all) do
    ssh_key = HCloud::SSHKey.create(name: "SSH Key", public_key: File.read(HCloud.root.join("spec/fixtures/one.pub")))
    server = described_class.create(name: "server", image: "debian-9", server_type: "cx11", location: "nbg1", ssh_keys: [ssh_key])
  end

  it "lists actions" do
    expect(server.actions.count).to eq 2
    expect(server.actions.map(&:command)).to match_array ["start_server", "create_server"]
  end

  it "finds action" do
    action_id = server.actions.sort(started: :desc).last.id

    action = server.actions.find(action_id)

    expect(action.command).to eq "start_server"
    expect(action.started).not_to be_nil
  end

  it "powers off" do
    sleep_until_unlocked(server)

    action = server.poweroff

    sleep_until(action) { action.status == "success" }

    expect(server.status).to eq "off"
  end

  it "adds to a placement group" do
    placement_group = HCloud::PlacementGroup.create(name: "Placement Group", type: "spread")

    server.add_to_placement_group(placement_group: placement_group)

    server.reload
    expect(server.placement_group).to eq placement_group
  end

  it "removes from a placement group" do
    server.remove_from_placement_group(placement_group: placement_group)

    server.reload

    expect(server.placement_group).to be_nil
  end

  it "powers on" do
    server.poweron

    sleep_until(server) { |s| s.status == "running" }

    expect(server.status).to eq "running"
  end

  # TODO: attach ISO
  xit "attaches an ISO"
  # TODO: detach ISO
  xit "detaches an ISO"

  # TODO: attach to network
  xit "attaches to a network"
  # TODO: detach from network
  xit "detaches from a network"

  # TODO: change alias IPs
  xit "changes alias IPs"
  # TODO: changedns ptr
  xit "change_dns_ptr"

  it "changes protection" do
    server.change_protection(delete: true, rebuild: true)

    sleep 1
    server.reload

    expect(server.protection).to be_delete
    expect(server.protection).to be_rebuild

    server.change_protection(delete: false, rebuild: false)
  end

  # TODO: change type
  xit "changes type"
  # TODO: create image
  xit "creates an image"

  # TODO: enable backup
  xit "enables backup"
  # TODO: disable backup
  xit "disables backup"

  # TODO: enable rescue
  xit "enables rescue"
  # TODO: disable rescue
  xit "disables rescue"

  # TODO: reboot
  xit "reboots"
  # TODO: reset
  xit "resets"
  # TODO: shutdown
  xit "shuts down"

  # TODO: reset_password
  xit "resets password"

  # TODO: rebuild
  xit "rebuilds"

  # TODO: request console
  xit "requests console"
end
