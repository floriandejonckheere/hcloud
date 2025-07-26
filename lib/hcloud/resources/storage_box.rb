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
  #     HCloud::StorageBox.where(label_selector: "environment=production")
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
  #     storage_box = HCloud::StorageBox.create(name: "my_storage_box", storage_box_type: "bx20", location: "fsn1", password: "my_password")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     Note: this endpoint returns an Action rather than the created resource itself
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
  # = Actions
  # == List actions
  #
  #     actions = HCloud::StorageBox.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::StorageBox.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::StorageBox.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::StorageBox.find(1).actions.where(command: "start_resource")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::StorageBox.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::StorageBox.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Resource-specific actions
  # == Change type
  #
  #     HCloud::StorageBox.find(1).change_type(storage_box_type: "bx21")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Reset password
  #
  #     HCloud::StorageBox.find(1).reset_password(password: "mypassword")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Update access settings
  #
  #     HCloud::StorageBox.find(1).update_access_settings(samba_enabled: false, ssh_enabled: true, webdav_enabled: false, zfs_enabled: false, reachable_externally: false)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Enable snapshot plan
  #
  #     HCloud::StorageBox.find(1).enable_snapshot_plan(max_snapshots: 10, minute: 30, hour: 3, day_of_week: nil, day_of_month: nil)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Disable snapshot plan
  #
  #     HCloud::StorageBox.find(1).disable_snapshot_plan
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Rollback snapshot
  #
  #     HCloud::StorageBox.find(1).rollback_snapshot(snapshot_id: 42)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change protection
  #
  #     HCloud::StorageBox.find(1).change_protection(delete: true)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Snapshots
  #
  # See {HCloud::StorageBoxSnapshot} for more information on snapshots.
  #
  # = Subaccounts
  #
  # See {HCloud::StorageBoxSubaccount} for more information on subaccounts.
  #
  class StorageBox < Resource
    actionable
    queryable
    creatable
    updatable
    deletable
    labelable

    subresource :snapshot, :storage_box_snapshot
    subresource :subaccount, :storage_box_subaccount

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

    action :change_type
    action :reset_password
    action :update_access_settings

    action :enable_snapshot_plan
    action :disable_snapshot_plan

    action :rollback_snapshot

    action :change_protection

    def contents(path: nil)
      client
        .get("#{resource_path}/#{id}/folders", path: path)
        .fetch(:folders)
    end

    def creatable_attributes
      [:name, :storage_box_type, :password, :ssh_keys, :location, :labels, access_settings: [:samba_enabled, :ssh_enabled, :webdav_enabled, :zfs_enabled, :reachable_externally]]
    end

    def updatable_attributes
      [:name, :labels]
    end

    def self.client
      HCloud::Client.connection.storage_box_client
    end
  end
end
