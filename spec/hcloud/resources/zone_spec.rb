# frozen_string_literal: true

RSpec.describe HCloud::Zone, :integration, order: :defined do
  after(:all) do
    described_class.all.each(&:delete)
  end

  zone_id = nil

  it "creates a primary IP" do
    zone = described_class.new(name: "#{SecureRandom.hex}.com", mode: "primary")

    expect(zone.create).to be_an(HCloud::Action)

    zone_id = zone.id

    expect(zone).to be_created
    expect(zone.id).not_to be_nil
  end

  it "creates rrset via the subresource" do
    zone = described_class.find(zone_id)

    rrset = zone.rrsets.new(name: "localhost",
                            type: "A",
                            ttl: 60,
                            records: [
                              value: "127.0.0.1", comment: "localhost",
                            ],)

    expect(rrset.create).to be_an(HCloud::Action)

    expect(rrset).not_to be_created
    expect(rrset.id).not_to be_nil
  end
end
