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

  describe "#put" do
    it "performs a HTTP PUT request" do
      stub = stub_request(:put, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(body: { foo: "bar" }.to_json)

      response = http.put("api", one: "two")

      expect(stub).to have_been_requested
      expect(response).to eq({ foo: "bar" })
    end
  end

  describe "#post" do
    it "performs a HTTP POST request" do
      stub = stub_request(:post, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(body: { foo: "bar" }.to_json)

      response = http.post("api", one: "two")

      expect(stub).to have_been_requested
      expect(response).to eq({ foo: "bar" })
    end
  end
end
