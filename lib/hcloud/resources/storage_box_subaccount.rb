# frozen_string_literal: true

module HCloud
  ##
  # Represents a storage box's subaccount
  #
  # == List all subaccounts
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.subaccounts
  #     # => [#<HCloud::StorageBox::Subaccount id: 1, ...>, ...]
  #
  # == Search subaccounts
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.subaccounts.where(label_selector: "environment=production")
  #     # => #<HCloud::StorageBox::Subaccount id: 1, ...>
  #
  # == Find subaccount by ID
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     storage_box.subaccounts.find(1)
  #     # => #<HCloud::StorageBox::Subaccount id: 1, ...>
  #
  # == Create subaccount
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     subaccount = storage_box.subaccounts.new(password: "my_password", description: "my_subaccount", home_directory: "backup/", access_settings: { samba_enabled: false, ssh_enabled: true, webdav_enabled: false, readonly: false, reachable_externally: false })
  #     subaccount.create
  #     subaccount.created?
  #     # => false
  #
  #     Note: this endpoint returns an Action rather than the created resource itself, as the subaccount is created asynchronously.
  #     Reload the subaccount to check if it was created successfully.
  #
  #     subaccount.reload
  #     subaccount.created?
  #     # => true
  #
  #     subaccount = storage_box.subaccounts.create(password: "my_password", description: "my_subaccount", home_directory: "backup/", access_settings: { samba_enabled: false, ssh_enabled: true, webdav_enabled: false, readonly: false, reachable_externally: false })
  #     # => #<HCloud::StorageBox::Subaccount id: 1, ...>
  #
  #     subaccount = HCloud::StorageBox::Subaccount.create(storage_box: 1, password: "my_password", description: "my_subaccount", home_directory: "backup/", access_settings: { samba_enabled: false, ssh_enabled: true, webdav_enabled: false, readonly: false, reachable_externally: false })
  #     # => #<HCloud::StorageBox::Subaccount id: 1, ...>
  #
  # == Update subaccount
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     subaccount = storage_box.subaccounts.find(1)
  #     subaccount.description = "another_subaccount"
  #     subaccount.update
  #
  # == Delete subaccount
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     subaccount = storage_box.subaccounts.find(1)
  #     subaccount.delete
  #     subaccount.deleted?
  #     # => true
  #
  # = Resource-specific actions
  # == Reset password
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     subaccount = storage_box.subaccounts.find(1)
  #     subaccount.reset_subaccount_password(password: "mypassword")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Update access settings
  #
  #     storage_box = HCloud::StorageBox.find(1)
  #     subaccount = storage_box.subaccounts.find(1)
  #     subaccount.update_access_settings(samba_enabled: false, ssh_enabled: true, webdav_enabled: false, zfs_enabled: false, reachable_externally: false)
  #     # => #<HCloud::Action id: 1, ...>
  #
  class StorageBoxSubaccount < Resource
    subresource_of :storage_box

    actionable
    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id, :integer
    attribute :username
    attribute :home_directory
    attribute :description
    attribute :comment

    # String, not a Server resource
    attribute :server

    attribute :access_settings, :storage_box_subaccount_access_settings

    attribute :protection, :protection

    # Creatable attributes
    attribute :password

    action :reset_subaccount_password
    action :update_access_settings

    def creatable_attributes
      [:password, :home_directory, :description, :labels, :access_settings]
    end

    def updatable_attributes
      [:description, :labels]
    end

    def self.client
      HCloud::Client.connection.storage_box_client
    end
  end
end
