# frozen_string_literal: true

RSpec.describe HCloud::ISO, integration: true, order: :defined do
  it "lists resources" do
    isos = described_class.all

    expect(isos.count).to be > 1
  end

  it "filters resources" do
    isos = described_class.all.where(name: "debian-10.10.0-amd64-netinst.iso")

    expect(isos.count).to eq 1
    expect(isos.first.id).to eq 7631
  end

  it "finds resources" do
    iso = described_class.find(7631)

    expect(iso.name).to eq "debian-10.10.0-amd64-netinst.iso"
    expect(iso.description).to eq "Debian 10.10 (amd64/netinstall)"

    expect(iso.type).to eq "public"
    expect(iso).not_to be_deprecated
  end
end
