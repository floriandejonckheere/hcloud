# frozen_string_literal: true

RSpec.describe HCloud::ServerType, :integration, order: :defined do
  it "lists server types" do
    server_types = described_class.all

    expect(server_types.count).to be > 1
  end

  it "filters server types" do
    server_types = described_class.all.where(name: "cx11")

    expect(server_types.count).to eq 1
    expect(server_types.first.id).to eq 1
  end

  it "finds server types" do
    server_type = described_class.find(1)

    expect(server_type.name).to eq "cx11"
    expect(server_type.description).to eq "CX11"

    expect(server_type.cores).to eq 1
    expect(server_type.disk).to eq 20
    expect(server_type.memory).to eq 2

    expect(server_type.cpu_type).to eq "shared"
    expect(server_type.storage_type).to eq "local"

    price = server_type.prices.find { |p| p.location == "fsn1" }

    expect(price.price_per_tb_traffic.net).not_to be_nil

    expect(price.price_monthly.net).not_to be_nil
    expect(price.price_hourly.net).not_to be_nil

    expect(server_type).not_to be_deprecated
  end
end
