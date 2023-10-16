# frozen_string_literal: true

RSpec.describe HCloud::Certificate, :integration, order: :defined do
  let(:public_key) { File.read(HCloud.root.join("spec/fixtures/three.cert")) }
  let(:private_key) { File.read(HCloud.root.join("spec/fixtures/three.key")) }

  certificate = nil

  before(:all) { certificate = described_class.create(name: "my_certificate", type: "managed", domain_names: ["example.com"]) }

  it "lists actions" do
    expect(certificate.actions.count).to eq 1
    expect(certificate.actions.map(&:command)).to eq ["create_certificate"]
  end

  it "finds action" do
    action_id = certificate.actions.first.id

    action = certificate.actions.find(action_id)

    expect(action.command).to eq "create_certificate"
    expect(action.started).not_to be_nil
  end

  it "retries issuance or renewal" do
    sleep 1
    certificate.retry

    expect(certificate.actions.count).to eq 2
    expect(certificate.actions.map(&:command)).to eq ["create_certificate", "retry_certificate"]
  end
end
