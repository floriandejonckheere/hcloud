# frozen_string_literal: true

RSpec.describe HCloud::Image, integration: true, order: :defined do
  it "finds an image" do
    image = described_class.find(2)

    expect(image.name).to eq "debian-9"
    expect(image.description).to eq "Debian 9"

    expect(image.type).to eq "system"
    expect(image.status).to eq "available"

    expect(image.build_id).to eq nil
    expect(image.disk_size).to eq 5
    expect(image.image_size).to eq nil

    expect(image.os_flavor).to eq "debian"
    expect(image.os_version).to eq "9"

    expect(image.protection).not_to be_delete

    expect(image.bound_to).to eq nil

    expect(image.created_from).to eq nil

    expect(image).to be_created
    expect(image).not_to be_deleted
    expect(image).not_to be_deprecated

    expect(image).to be_rapid_deploy
  end

  it "finds another image" do
    image = described_class.find(40_093_134)

    expect(image.name).to eq "wordpress"
    expect(image.description).to eq "wordpress"

    expect(image.type).to eq "app"
    expect(image.status).to eq "available"

    expect(image.build_id).to eq nil
    expect(image.disk_size).to eq 20
    expect(image.image_size).to eq nil

    expect(image.os_flavor).to eq "ubuntu"
    expect(image.os_version).to eq "unknown"

    expect(image.protection).not_to be_delete

    expect(image.bound_to).to eq nil

    expect(image.created_from).to eq nil

    expect(image).to be_created
    expect(image).not_to be_deleted
    expect(image).not_to be_deprecated

    expect(image).not_to be_rapid_deploy
  end

  it "lists images" do
    images = described_class.all

    expect(images.count).to be > 2
    expect(images.map(&:id)).to include(2, 40_093_134)
  end

  it "sorts images" do
    images = described_class.all.sort(name: :desc)

    expect(images.first.name).to eq "wordpress"
  end

  it "filters images" do
    images = described_class.all.where(name: "debian-9")

    expect(images.count).to eq 1
    expect(images.first.id).to eq 2
  end

  # TODO: updates an image
  xit "updates an image"

  # TODO: deletes an image
  xit "deletes an image"
end
