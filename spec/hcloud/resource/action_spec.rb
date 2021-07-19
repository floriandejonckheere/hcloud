# frozen_string_literal: true

RSpec.describe HCloud::Action, integration: true, order: :defined do
  id_one, id_two = nil

  xit "finds an action" do
    action = described_class.find(id_one)

    expect(action.status).to eq "success"
  end

  xit "lists actions" do
    actions = described_class.all

    expect(actions.count).to eq 1
    expect(actions.map(&:id)).to match_array []
  end

  xit "sorts actions" do
    actions = described_class.all.sort(status: :asc)

    expect(actions.count).to eq 2
    expect(actions.map(&:id)).to eq [id_two, id_one]
  end

  xit "filters actions" do
    actions = described_class.all.where(status: "success")

    expect(actions.count).to eq 1
    expect(actions.first.id).to eq id_one
  end
end
