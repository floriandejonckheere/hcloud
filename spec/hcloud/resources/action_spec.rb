# frozen_string_literal: true

RSpec.describe HCloud::Action, :integration, order: :defined do
  id_one, id_two = nil # rubocop:disable RSpec/LeakyLocalVariable

  # TODO: finds an action
  xit "finds an action" do
    action = described_class.find(id_one)

    expect(action.status).to eq "success"
  end

  # TODO: lists actions
  xit "lists actions" do
    actions = described_class.all

    expect(actions.count).to eq 1
    expect(actions.map(&:id)).to be_empty
  end

  # TODO: sorts actions
  xit "sorts actions" do
    actions = described_class.all.sort(status: :asc)

    expect(actions.count).to eq 2
    expect(actions.map(&:id)).to eq [id_two, id_one]
  end

  # TODO: filters actions
  xit "filters actions" do
    actions = described_class.all.where(status: "success")

    expect(actions.count).to eq 1
    expect(actions.first.id).to eq id_one
  end
end
