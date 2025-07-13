# frozen_string_literal: true

module HCloud
  class StorageBoxType < Entity
    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :size, :integer

    attribute :snapshot_limit, :integer
    attribute :automatic_snapshot_limit, :integer
    attribute :subaccounts_limit, :integer

    attribute :prices, :storage_box_price, array: true, default: -> { [] }

    attribute :deprecation, :deprecation
  end
end
