# frozen_string_literal: true

RSpec.describe HTTP::MimeType::YAML do
  subject(:adapter) { described_class.new }

  it "parses YAML requests" do
    stub_request(:get, "http://127.0.0.1/test.yml")
      .to_return(body: { "foo" => "bar" }.to_yaml)

    test = HTTP
      .get("http://127.0.0.1/test.yml")
      .parse(:yaml)

    expect(test).to eq "foo" => "bar"
  end
end
