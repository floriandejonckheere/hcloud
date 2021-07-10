# frozen_string_literal: true

RSpec.describe HCloud::Resource::SSHKey do
  subject(:resource) { build(:ssh_key) }

  it "has default labels" do
    expect(described_class.new.labels).to eq({})
  end
end
