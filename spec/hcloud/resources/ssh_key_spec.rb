# frozen_string_literal: true

RSpec.describe HCloud::SSHKey, :integration, order: :defined do
  let(:file_one) { File.read(HCloud.root.join("spec/fixtures/one.pub")) }
  let(:file_two) { File.read(HCloud.root.join("spec/fixtures/two.pub")) }

  id_one, id_two = nil

  it "creates a SSH key" do
    ssh_key = described_class.new(name: "first_ssh_key", public_key: file_one)

    ssh_key.create

    expect(ssh_key).to be_created
    expect(ssh_key.id).not_to be_nil

    id_one = ssh_key.id
  end

  it "creates another SSH key" do
    ssh_key = described_class.new(name: "second_ssh_key", public_key: file_two)

    ssh_key.create

    expect(ssh_key).to be_created
    expect(ssh_key.id).not_to be_nil

    id_two = ssh_key.id
  end

  it "finds an SSH key" do
    ssh_key = described_class.find(id_one)

    expect(ssh_key.name).to eq "first_ssh_key"
    expect(ssh_key.public_key).to eq file_one
  end

  it "lists SSH keys" do
    ssh_keys = described_class.all

    expect(ssh_keys.count).to eq 2
    expect(ssh_keys.map(&:id)).to contain_exactly(id_one, id_two)
  end

  it "sorts SSH keys" do
    ssh_keys = described_class.all.sort(name: :desc)

    expect(ssh_keys.count).to eq 2
    expect(ssh_keys.map(&:id)).to eq [id_two, id_one]
  end

  it "filters SSH keys" do
    ssh_keys = described_class.all.where(name: "first_ssh_key")

    expect(ssh_keys.count).to eq 1
    expect(ssh_keys.first.id).to eq id_one
  end

  it "updates a SSH key" do
    ssh_key = described_class.find(id_one)

    ssh_key.name = "my_other_ssh_key"

    ssh_key.update

    ssh_key = described_class.find(id_one)

    expect(ssh_key.name).to eq "my_other_ssh_key"
  end

  it "deletes a SSH key" do
    ssh_key = described_class.find(id_one)

    ssh_key.delete

    expect(ssh_key).to be_deleted

    expect { described_class.find(id_one) }.to raise_error HCloud::Errors::NotFound
  end
end
