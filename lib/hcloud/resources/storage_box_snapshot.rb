# frozen_string_literal: true

module HCloud
  ##
  # Represents a storage box's snapshot
  #
  # == List all snapshots
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.snapshots
  #     # => [#<HCloud::StorageBox::Snapshot id: 1, ...>, ...]
  #
  # == Search snapshots
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.snapshots.where(name: "monthly_backup")
  #     # => #<HCloud::StorageBox::Snapshot id: 1, ...>
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.snapshots.where(label_selector: "environment=production")
  #     # => #<HCloud::StorageBox::Snapshot id: 1, ...>
  #
  # == Find snapshot by ID
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.snapshots.find(1)
  #     # => #<HCloud::StorageBox::Snapshot id: 1, ...>
  #
  # == Create snapshot
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     snapshot = storage_box.snapshots.new(description: "my_snapshot")
  #     snapshot.create
  #     snapshot.created?
  #     # => false
  #
  #     Note: this endpoint returns an Action rather than the created resource itself, as the snapshot is created asynchronously.
  #     Reload the snapshot to check if it was created successfully.
  #
  #     snapshot.reload
  #     snapshot.created?
  #     # => true
  #
  #     snapshot = storage_box.snapshots.create(description: "my_snapshot")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     Note: this endpoint returns an Action rather than the created resource itself
  #
  #     snapshot = HCloud::StorageBox::Snapshot.create(storage_box: 1, description: "my_snapshot")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     Note: this endpoint returns an Action rather than the created resource itself
  #
  # == Update snapshot
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     snapshot = storage_box.snapshots.find(1)
  #     snapshot.description = "another_snapshot"
  #     snapshot.update
  #
  # == Delete snapshot
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     snapshot = storage_box.snapshots.find(1)
  #     snapshot.delete
  #     snapshot.deleted?
  #     # => true
  #
  class StorageBoxSnapshot < Resource
    subresource_of :storage_box

    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :is_automatic, :boolean

    attribute :stats, :storage_box_snapshot_stats

    attribute :protection, :protection

    def creatable_attributes
      [:description]
    end

    def updatable_attributes
      [:description, :labels]
    end

    def self.resource_name
      "snapshot"
    end

    def self.client
      HCloud::Client.connection.storage_box_client
    end
  end
end
