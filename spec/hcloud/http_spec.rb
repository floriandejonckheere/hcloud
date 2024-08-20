# frozen_string_literal: true

RSpec.describe HCloud::HTTP do
  subject(:http) { described_class.new("access_token", "https://endpoint/", Logger.new("/dev/null"), false, 10, compression) }

  let(:compression) { nil }

  describe "#initialize" do
    it "initializes the HTTP client" do
      expect(http.access_token).to eq "access_token"
      expect(http.endpoint).to eq "https://endpoint/"
      expect(http.logger).to be_a Logger
      expect(http.rate_limit).to be false
      expect(http.timeout).to eq 10
      expect(http.compression).to be_nil
    end

    context "when compression is enabled (gzip)" do
      let(:compression) { "gzip" }

      it "initializes the HTTP client" do
        expect(http.compression).to eq "gzip"
      end
    end

    context "when compression is enabled (invalid)" do
      let(:compression) { "invalid" }

      it "raises an error for invalid compression algorithm" do
        expect { http }.to raise_error(ArgumentError, "invalid compression algorithm: invalid")
      end
    end
  end

  describe "#get" do
    it "performs a HTTP GET request and returns the response payload" do
      stub = stub_request(:get, "https://endpoint/api")
        .with(query: { one: "two" })
        .to_return(body: { foo: "bar" }.to_json)

      response = http.get("api", one: "two")

      expect(stub).to have_been_requested
      expect(response).to eq({ foo: "bar" })
    end

    it "raises a client error" do
      stub = stub_request(:get, "https://endpoint/api")
        .with(query: { one: "two" })
        .to_return(status: 422, body: { error: { code: "invalid_input", message: "Invalid Input" } }.to_json)

      expect { http.get("api", one: "two") }.to raise_error HCloud::Errors::InvalidInput
      expect(stub).to have_been_requested
    end

    it "raises a server error" do
      stub = stub_request(:get, "https://endpoint/api")
        .with(query: { one: "two" })
        .to_return(status: 503, body: nil)

      expect { http.get("api", one: "two") }.to raise_error HCloud::Errors::ServerError
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

    it "raises a client error" do
      stub = stub_request(:put, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(status: 422, body: { error: { code: "invalid_input", message: "Invalid Input" } }.to_json)

      expect { http.put("api", one: "two") }.to raise_error HCloud::Errors::InvalidInput
      expect(stub).to have_been_requested
    end

    it "raises a server error" do
      stub = stub_request(:put, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(status: 503, body: nil)

      expect { http.put("api", one: "two") }.to raise_error HCloud::Errors::ServerError
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

    it "raises a client error" do
      stub = stub_request(:post, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(status: 422, body: { error: { code: "invalid_input", message: "Invalid Input" } }.to_json)

      expect { http.post("api", one: "two") }.to raise_error HCloud::Errors::InvalidInput
      expect(stub).to have_been_requested
    end

    it "raises a server error" do
      stub = stub_request(:post, "https://endpoint/api")
        .with(body: { one: "two" })
        .to_return(status: 503, body: nil)

      expect { http.post("api", one: "two") }.to raise_error HCloud::Errors::ServerError
      expect(stub).to have_been_requested
    end
  end

  describe "#delete" do
    it "performs a HTTP DELETE request" do
      stub = stub_request(:delete, "https://endpoint/api")

      http.delete("api")

      expect(stub).to have_been_requested
    end

    it "raises a client error" do
      stub = stub_request(:delete, "https://endpoint/api")
        .to_return(status: 422, body: { error: { code: "invalid_input", message: "Invalid Input" } }.to_json)

      expect { http.delete("api") }.to raise_error HCloud::Errors::InvalidInput
      expect(stub).to have_been_requested
    end

    it "raises a server error" do
      stub = stub_request(:delete, "https://endpoint/api")
        .to_return(status: 503, body: nil)

      expect { http.delete("api") }.to raise_error HCloud::Errors::ServerError
      expect(stub).to have_been_requested
    end
  end
end
