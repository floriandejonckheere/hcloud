# frozen_string_literal: true

RSpec.describe HTTP::Features::Compression do
  subject(:feature) { described_class.new(**options) }

  let(:options) { {} }

  let(:request) { HTTP::Request.new(verb: :get, uri: "http://localhost", body: "Hello, World!") }

  it "defaults to gzip compression" do
    expect(feature.method).to eq "gzip"
  end

  describe "gzip compression" do
    let(:options) { { method: "gzip" } }

    let(:connection) { mock_connection(compress("Hello, World!", :gzip)) }

    let(:response) { HTTP::Response.new(version: "1.1", status: 200, headers: { "Content-Encoding" => "gzip" }, connection: connection, request: request) }

    describe "#wrap_request" do
      it "compresses the request body" do
        wrapped_request = feature.wrap_request(request)

        expect(wrapped_request.headers["Content-Encoding"]).to eq "gzip"
        expect(decompress(wrapped_request.body.each.to_a.join, :gzip)).to eq "Hello, World!"
      end
    end

    describe "#wrap_response" do
      it "decompresses the response body" do
        wrapped_response = feature.wrap_response(response)

        expect(wrapped_response.body.to_s).to eq "Hello, World!"
      end
    end
  end

  def mock_connection(body)
    double.tap do |connection|
      allow(connection)
        .to receive(:readpartial)
        .and_return(
          body, # first chunk
          false # end of stream
        )
    end
  end
end
