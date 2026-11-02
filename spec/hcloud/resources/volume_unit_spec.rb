# frozen_string_literal: true

RSpec.describe HCloud::Volume do
  describe "#create" do
    it "serializes assignee correctly" do
      volume = described_class.new(name: "my-volume", size: 10, location: "fsn1", assignee: { id: 1, type: "server" })

      stub_request(:post, "https://api.hetzner.cloud/v1/volumes")
        .with(body: {
                name: "my-volume",
                size: 10,
                location: "fsn1",
                assignee: { id: 1, type: "server" },
              })
        .to_return(body: { volume: { id: 1, name: "my-volume", size: 10, assignee: { id: 1, type: "server" }, created: 1.second.ago } }.to_json)

      volume.create

      expect(volume).to be_created
      expect(volume.assignee.id).to eq 1
      expect(volume.assignee.type).to eq "server"
    end
  end

  describe "#server" do
    it "warns about deprecation" do
      volume = described_class.new(server: 1)

      expect { volume.server }.to output(/\[DEPRECATION\] Field "server" on HCloud::Volume is deprecated/).to_stderr
    end
  end
end
