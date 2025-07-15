# frozen_string_literal: true

module HCloud
  ##
  # Represents a storage box
  #
  # == List all storage boxes
  #
  #     HCloud::StorageBox.all
  #     # => [#<HCloud::StorageBox id: 1, ...>, ...]
  #
  # == Search storage boxes
  #
  #     HCloud::StorageBox.where(name: "my_storage_box")
  #     # => #<HCloud::StorageBox id: 1, ...>
  #
  #     HCloud::StorageBox.where(label_selector: { environment: "production" })
  #     # => #<HCloud::StorageBox id: 1, ...>
  #
  # == Find storage box by ID
  #
  #     HCloud::StorageBox.find(1)
  #     # => #<HCloud::StorageBox id: 1, ...>
  #
  # == Create storage box
  #
  #     storage_box = HCloud::StorageBox.new(name: "my_storage_box", storage_box_type: "bx20", location: "fsn1", password: "my_password")
  #     storage_box.create
  #     storage_box.created?
  #     # => true
  #
  #     firewall = HCloud::StorageBox.create(name: "my_storage_box", storage_box_type: "bx20", location: "fsn1", password: "my_password")
  #     # => #<HCloud::StorageBox id: 1, ...>
  #
  # == Update storage box
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.name = "another_storage_box"
  #     storage_box.update
  #
  # == Delete storage box
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.delete
  #     storage_box.deleted?
  #     # => true
  #
  # == List storage box contents
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.contents
  #     # => ["photos", "documents", ...]
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.contents(folder: "photos")
  #     # => ["photo1.jpg", "photo2.jpg", ...]
  #
  class StorageBox < Resource
    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id, :integer
    attribute :name
    attribute :location, :location

    attribute :username

    attribute :status

    attribute :storage_box_type, :storage_box_type
    attribute :access_settings, :storage_box_access_settings

    # String, not a Server resource
    attribute :server
    attribute :system

    attribute :stats, :storage_box_stats
    attribute :snapshot_plan, :storage_box_snapshot_plan

    attribute :protection, :protection

    def contents(folder: nil)
      client
        .get("/#{resource_name.pluralize}/#{id}/folders", folder: folder)
        .fetch(:folders)
    end

    def creatable_attributes
      [:name, :storage_box_type, :password, :ssh_keys, :location, :access_settings, :labels]
    end

    def updatable_attributes
      [:name, :labels]
    end

    def self.client
      HCloud::Client.connection.storage_box_client
    end
  end
end
