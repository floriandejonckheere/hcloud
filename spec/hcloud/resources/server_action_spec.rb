# frozen_string_literal: true

RSpec.describe HCloud::Server, integration: true, order: :defined do
  server = nil

  before(:all) do
    ssh_key = HCloud::SSHKey.create(name: "SSH Key", public_key: File.read(HCloud.root.join("spec/fixtures/one.pub")))
    server = described_class.create(name: "server", image: "debian-11", server_type: "cx11", location: "nbg1", ssh_keys: [ssh_key])
  end

  it "lists actions" do
    expect(server.actions.count).to eq 2
    expect(server.actions.map(&:command)).to contain_exactly("start_resource", "create_resource")
  end

  it "finds action" do
    action_id = server.actions.last.id

    action = server.actions.find(action_id)

    expect(action.command).to eq "create_server"
    expect(action.started).not_to be_nil
  end

  # TODO: add to placement group
  xit "adds to a placement group"
  # TODO: remove from placement group
  xit "removes from a placement group"

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

  # TODO: poweron
  xit "powers on"
  # TODO: poweroff
  xit "powers off"
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
