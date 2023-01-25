# frozen_string_literal: true

RSpec.describe HCloud::Metadata do
  subject(:metadata) { described_class.find }

  it "finds the metadata" do
    stub_request(:get, "https://169.254.169.254/hetzner/v1/metadata")
      .to_return(body: File.read("spec/fixtures/metadata.yml"))

    expect(metadata.hostname).to eq "cloud"
    expect(metadata.instance_id).to eq 12_345
    expect(metadata.public_ipv4).to eq "123.123.123.123"
    expect(metadata.availability_zone).to eq "fsn1-dc8"
    expect(metadata.region).to eq "eu-central"

    expect(metadata.private_networks).not_to be_empty

    private_network = metadata.private_networks.find { |p| p.ip == "10.0.0.2" }
    expect(private_network.ip).to eq "10.0.0.2"
    expect(private_network.alias_ips).to eq ["10.0.0.3", "10.0.0.4"]
    expect(private_network.interface_num).to eq 1
    expect(private_network.mac_address).to eq "86:00:00:2a:7d:e0"
    expect(private_network.network_id).to eq 1234
    expect(private_network.network_name).to eq "nw-test1"
    expect(private_network.network).to eq "10.0.0.0/8"
    expect(private_network.subnet).to eq "10.0.0.0/24"
    expect(private_network.gateway).to eq "10.0.0.1"
  end
end
