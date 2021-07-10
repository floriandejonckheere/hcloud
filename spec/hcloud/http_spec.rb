# frozen_string_literal: true

RSpec.describe HCloud::HTTP do
  subject(:http) { described_class.new("access_token", "https://endpoint/") }

  describe "#get" do
    it "performs a HTTP GET request and returns the response payload" do
      stub = stub_request(:get, "https://endpoint/api")
        .with(query: { one: "two" })
        .to_return(body: { foo: "bar" }.to_json)

      response = http.get("api", one: "two")

      expect(stub).to have_been_requested
      expect(response).to eq({ foo: "bar" })
    end

    it "raises an error" do
      stub = stub_request(:get, "https://endpoint/api")
        .with(query: { one: "two" })
        .to_return(status: 500, body: { error: { message: "Internal Server Error" } }.to_json)

      expect { http.get("api", one: "two") }.to raise_error HCloud::Error
      expect(stub).to have_been_requested
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

    it "raises an error" do
      stub = stub_request(:put, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(status: 500, body: { error: { message: "Internal Server Error" } }.to_json)

      expect { http.put("api", one: "two") }.to raise_error HCloud::Error
      expect(stub).to have_been_requested
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

    it "raises an error" do
      stub = stub_request(:post, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(status: 500, body: { error: { message: "Internal Server Error" } }.to_json)

      expect { http.post("api", one: "two") }.to raise_error HCloud::Error
      expect(stub).to have_been_requested
    end
  end

  describe "#delete" do
    it "performs a HTTP DELETE request" do
      stub = stub_request(:delete, "https://endpoint/api")
        .to_return(body: { foo: "bar" }.to_json)

      http.delete("api")

      expect(stub).to have_been_requested
    end

    it "raises an error" do
      stub = stub_request(:delete, "https://endpoint/api")
        .to_return(status: 500, body: { error: { message: "Internal Server Error" } }.to_json)

      expect { http.delete("api") }.to raise_error HCloud::Error
      expect(stub).to have_been_requested
    end
  end
end
