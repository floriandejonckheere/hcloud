# frozen_string_literal: true

RSpec.describe HCloud::Datacenter, integration: true, order: :defined do
  it "lists datacenters" do
    datacenters = described_class.all

    expect(datacenters.count).to be > 1
  end

  it "sorts datacenters" do
    datacenters = described_class.all.sort(name: :desc)

    expect(datacenters.first.name).to eq "nbg1-dc3"
  end

  it "filters datacenters" do
    datacenters = described_class.all.where(name: "nbg1-dc3")

    expect(datacenters.count).to eq 1
    expect(datacenters.first.id).to eq 2
  end

  it "finds datacenters" do
    datacenter = described_class.find(2)

    expect(datacenter.name).to eq "nbg1-dc3"
    expect(datacenter.description).to eq "Nuremberg 1 DC 3"

    expect(datacenter.location.id).to eq 2
    expect(datacenter.location.name).to eq "nbg1"

    expect(datacenter.server_types.available).not_to be_empty
  end

  it "returns recommendation" do
    expect(described_class.recommendation).to be_a described_class
  end
end
