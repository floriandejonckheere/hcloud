# frozen_string_literal: true

RSpec.describe HCloud::Location, integration: true, order: :defined do
  it "lists locations" do
    locations = described_class.all

    expect(locations.count).to be > 1
  end

  it "filters locations" do
    locations = described_class.all.where(name: "fsn1")

    expect(locations.count).to eq 1
    expect(locations.first.id).to eq 1
  end

  it "sorts locations" do
    locations = described_class.all.sort(name: :desc)

    expect(locations.first.name).to eq "nbg1"
  end

  it "finds locations" do
    location = described_class.find(1)

    expect(location.name).to eq "fsn1"
    expect(location.description).to eq "Falkenstein DC Park 1"

    expect(location.network_zone).to eq "eu-central"

    expect(location.city).to eq "Falkenstein"
    expect(location.country).to eq "DE"

    expect(location.latitude).to eq 50.47612
    expect(location.longitude).to eq 12.370071
  end
end
