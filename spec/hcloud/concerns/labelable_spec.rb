# frozen_string_literal: true

RSpec.describe HCloud::Actionable do
  subject(:resource) { ExampleResource.new(id: 1) }

  describe "#labels" do
    it "has labels" do
      expect(resource.labels).to be_empty
    end
  end
end
