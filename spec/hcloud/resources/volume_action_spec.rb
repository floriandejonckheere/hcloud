# frozen_string_literal: true

RSpec.describe HCloud::Volume, :integration, order: :defined do
  volume, server = nil

  before(:all) do
    volume = described_class.create(name: "volume", size: 10, location: "nbg1")
    server = HCloud::Server.create(name: "server", image: "debian-11", server_type: "cx11", location: "nbg1")
  end

  it "lists actions" do
    expect(volume.actions.count).to eq 1
    expect(volume.actions.map(&:command)).to eq ["create_volume"]
  end

  it "finds action" do
    action_id = volume.actions.first.id

    action = volume.actions.find(action_id)

    expect(action.command).to eq "create_volume"
    expect(action.started).not_to be_nil
  end

  xit "attaches a volume" do
    volume.attach(server: server.id, automount: false)

    sleep 1
    volume.reload

    expect(volume.server).to eq server
  end

  xit "detaches a volume" do
    volume.detach

    sleep 1
    volume.reload

    expect(volume.server).to be_nil
  end

  it "resizes the volume" do
    volume.resize(size: 11)

    sleep 1
    volume.reload

    expect(volume.size).to eq 11
  end

  it "changes protection" do
    volume.change_protection(delete: true)

    volume.reload

    expect(volume.protection).to be_delete

    volume.change_protection(delete: false)
  end
end
