# frozen_string_literal: true

RSpec.describe HCloud::ServerType, integration: true, order: :defined do
  it "lists resources" do
    server_types = described_class.all

    expect(server_types.count).to be > 1
  end

  it "filters resources" do
    server_types = described_class.all.where(name: "cx11")

    expect(server_types.count).to eq 1

    server_type = server_types.first

    expect(server_type.description).to eq "CX11"
    expect(server_type.cores).to eq 1
    expect(server_type.disk).to eq 20
    expect(server_type.memory).to eq 2

    expect(server_type.cpu_type).to eq "shared"
    expect(server_type.storage_type).to eq "local"
  end
end
