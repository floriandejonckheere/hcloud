# frozen_string_literal: true

module HCloud
  ##
  # Represents a storage box type
  #
  # == List all storage box types
  #
  #     HCloud::StorageBoxType.all
  #     # => [#<HCloud::StorageBoxType id: 1, ...>, ...]
  #
  # == Search storage box types
  #
  #     HCloud::StorageBoxType.where(name: "bx11")
  #     # => #<HCloud::StorageBoxType id: 1, ...>
  #
  # == Find storage box type by ID
  #
  #     HCloud::StorageBoxType.find(1)
  #     # => #<HCloud::StorageBoxType id: 1, ...>
  #
  class StorageBoxType < Resource
    queryable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :size, :integer

    attribute :snapshot_limit, :integer
    attribute :automatic_snapshot_limit, :integer
    attribute :subaccounts_limit, :integer

    attribute :prices, :storage_box_price, array: true, default: -> { [] }

    attribute :deprecation, :deprecation

    def self.client
      HCloud::Client.connection.storage_box_client
    end
  end
end
