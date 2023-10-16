# frozen_string_literal: true

RSpec.describe HCloud::Volume, :integration, order: :defined do
  id_one, id_two = nil

  after(:all) do
    described_class.all.each { |m| m.change_protection(delete: false) }
    described_class.all.each(&:delete)
  end

  it "creates a volume" do
    volume = described_class.new(name: "first_volume", size: 10, format: "ext4", automount: false, location: "fsn1")

    volume.create

    expect(volume).to be_created
    expect(volume.id).not_to be_nil

    id_one = volume.id
  end

  it "creates another volume" do
    volume = described_class.new(name: "second_volume", size: 10, format: "ext4", automount: false, location: "nbg1")

    volume.create

    expect(volume).to be_created
    expect(volume.id).not_to be_nil

    id_two = volume.id
  end

  it "finds a volume" do
    volume = described_class.find(id_one)

    expect(volume.name).to eq "first_volume"
    expect(volume.format).to eq "ext4"
    expect(volume.size).to eq 10
    expect(volume.linux_device).not_to be_empty

    expect(volume.location.name).to eq "fsn1"
    expect(volume.protection).not_to be_delete

    expect(volume.server).to be_nil
  end

  it "lists volumes" do
    volumes = described_class.all

    expect(volumes.count).to eq 2
    expect(volumes.map(&:id)).to contain_exactly(id_one, id_two)
  end

  it "sorts volumes" do
    volumes = described_class.all.sort(name: :desc)

    expect(volumes.count).to eq 2
    expect(volumes.map(&:id)).to eq [id_two, id_one]
  end

  it "filters volumes" do
    volumes = described_class.all.where(name: "first_volume")

    expect(volumes.count).to eq 1
    expect(volumes.first.id).to eq id_one
  end

  it "updates a volume" do
    volume = described_class.find(id_one)

    volume.name = "other_volume"

    volume.update

    volume = described_class.find(id_one)

    expect(volume.name).to eq "other_volume"
  end

  it "deletes a volume" do
    volume = described_class.find(id_one)

    volume.delete

    expect(volume).to be_deleted

    expect { described_class.find(id_one) }.to raise_error HCloud::Errors::NotFound
  end
end
