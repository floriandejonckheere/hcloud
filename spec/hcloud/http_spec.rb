# frozen_string_literal: true

RSpec.describe HCloud::HTTP do
  subject(:http) { described_class.new("access_token", "https://endpoint/") }

  describe "#get" do
    it "performs a HTTP GET request" do
      stub = stub_request(:get, "https://endpoint/api")
        .with(query: { one: "two" })
        .to_return(body: { foo: "bar" }.to_json)

      response = http.get("api", one: "two")

      expect(stub).to have_been_requested
      expect(response).to eq({ foo: "bar" })
    end
  end
end
