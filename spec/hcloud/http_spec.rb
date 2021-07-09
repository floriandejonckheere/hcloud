# frozen_string_literal: true

RSpec.describe HCloud::HTTP do
  subject(:http) { described_class.new("https://endpoint/", "access_token") }

  describe "#get" do
    it "performs a HTTP GET request" do
      stub = stub_request(:get, "https://endpoint/api")
        .with(query: { one: "two" })
        .to_return(body: "{}")

      http.get("api", one: "two")

      expect(stub).to have_been_requested
    end
  end
end
