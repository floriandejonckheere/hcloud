# frozen_string_literal: true

RSpec.describe HCloud::PlacementGroup, integration: true, order: :defined do
  id_one, id_two = nil

  it "creates a placement group" do
    placement_group = described_class.new(name: "first_placement_group", type: "spread")

    placement_group.create

    expect(placement_group).to be_created
    expect(placement_group.id).not_to be_nil

    id_one = placement_group.id
  end

  it "creates another placement group" do
    placement_group = described_class.new(name: "second_placement_group", type: "spread")

    placement_group.create

    expect(placement_group).to be_created
    expect(placement_group.id).not_to be_nil

    id_two = placement_group.id
  end

  it "finds an placement group" do
    placement_group = described_class.find(id_one)

    expect(placement_group.name).to eq "first_placement_group"
    expect(placement_group.type).to eq "spread"
  end

  it "lists placement groups" do
    placement_groups = described_class.all

    expect(placement_groups.count).to eq 2
    expect(placement_groups.map(&:id)).to contain_exactly(id_one, id_two)
  end

  it "sorts placement groups" do
    placement_groups = described_class.all.sort(name: :desc)

    expect(placement_groups.count).to eq 2
    expect(placement_groups.map(&:id)).to eq [id_two, id_one]
  end

  it "filters placement groups" do
    placement_groups = described_class.all.where(name: "first_placement_group")

    expect(placement_groups.count).to eq 1
    expect(placement_groups.first.id).to eq id_one
  end

  it "updates a placement group" do
    placement_group = described_class.find(id_one)

    placement_group.name = "my_other_placement_group"

    placement_group.update

    placement_group = described_class.find(id_one)

    expect(placement_group.name).to eq "my_other_placement_group"
  end

  it "deletes a placement group" do
    placement_group = described_class.find(id_one)

    placement_group.delete

    expect(placement_group).to be_deleted

    expect { described_class.find(id_one) }.to raise_error HCloud::Errors::NotFound
  end
end
