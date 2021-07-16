# frozen_string_literal: true

RSpec.describe HCloud::SSHKey, integration: true, order: :defined do
  let(:file) { File.read(HCloud.root.join("spec/fixtures/ssh_key.pub")) }

  id = nil

  it "creates a resource" do
    # Create SSH key
    ssh_key = described_class.new(name: "My SSH Key", public_key: file)

    ssh_key.create

    expect(ssh_key).to be_created
    expect(ssh_key.id).not_to be_nil

    id = ssh_key.id
  end

  it "finds a resource" do
    ssh_key = described_class.find(id)

    expect(ssh_key.name).to eq "My SSH Key"
    expect(ssh_key.public_key).to eq file
  end

  it "updates a resource" do
    ssh_key = described_class.find(id)

    ssh_key.name = "My Other SSH Key"

    ssh_key.update

    ssh_key = described_class.find(id)

    expect(ssh_key.name).to eq "My Other SSH Key"
  end

  it "deletes a resource" do
    ssh_key = described_class.find(id)

    ssh_key.delete

    expect(ssh_key).to be_deleted

    expect { described_class.find(id) }.to raise_error HCloud::Errors::NotFound
  end
end
