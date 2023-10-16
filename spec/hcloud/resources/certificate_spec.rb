# frozen_string_literal: true

RSpec.describe HCloud::Certificate, :integration, order: :defined do
  let(:public_key) { File.read(HCloud.root.join("spec/fixtures/three.cert")) }
  let(:private_key) { File.read(HCloud.root.join("spec/fixtures/three.key")) }

  managed_certificate_id, uploaded_certificate_id = nil

  it "creates a managed certificate" do
    certificate = described_class.new(name: "managed_certificate", type: "managed", domain_names: ["example.com"])

    certificate.create

    expect(certificate).to be_created
    expect(certificate.id).not_to be_nil

    managed_certificate_id = certificate.id
  end

  it "creates an uploaded certificate" do
    certificate = described_class.new(name: "uploaded_certificate", type: "uploaded", private_key: private_key, certificate: public_key)

    certificate.create

    expect(certificate).to be_created
    expect(certificate.id).not_to be_nil

    uploaded_certificate_id = certificate.id
  end

  it "finds a certificate" do
    certificate = described_class.find(managed_certificate_id)

    expect(certificate.name).to eq "managed_certificate"
    expect(certificate.type).to eq "managed"
    expect(certificate.domain_names).to include "example.com"

    certificate = described_class.find(uploaded_certificate_id)

    expect(certificate.name).to eq "uploaded_certificate"
    expect(certificate.type).to eq "uploaded"
    expect(certificate.certificate).to include "BEGIN CERTIFICATE"
  end

  it "lists certificates" do
    certificates = described_class.all

    expect(certificates.count).to eq 2
    expect(certificates.map(&:id)).to contain_exactly(managed_certificate_id, uploaded_certificate_id)
  end

  it "sorts certificates" do
    certificates = described_class.all.sort(name: :desc)

    expect(certificates.count).to eq 2
    expect(certificates.map(&:id)).to eq [uploaded_certificate_id, managed_certificate_id]
  end

  it "filters certificates" do
    certificates = described_class.all.where(name: "managed_certificate")

    expect(certificates.count).to eq 1
    expect(certificates.first.id).to eq managed_certificate_id

    certificates = described_class.all.where(type: "uploaded")

    expect(certificates.count).to eq 1
    expect(certificates.first.id).to eq uploaded_certificate_id
  end

  it "updates a certificate" do
    certificate = described_class.find(managed_certificate_id)

    certificate.name = "my_other_certificate"

    certificate.update

    certificate = described_class.find(managed_certificate_id)

    expect(certificate.name).to eq "my_other_certificate"
  end

  it "deletes a certificate" do
    certificate = described_class.find(managed_certificate_id)

    certificate.delete

    expect(certificate).to be_deleted

    expect { described_class.find(managed_certificate_id) }.to raise_error HCloud::Errors::NotFound
  end
end
