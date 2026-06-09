# frozen_string_literal: true

RSpec.describe HCloud::Action, :integration, order: :defined do
  id_one, = nil # rubocop:disable RSpec/LeakyLocalVariable

  # TODO: finds an action
  xit "finds an action" do
    action = described_class.find(id_one)

    expect(action.status).to eq "success"
  end
end
