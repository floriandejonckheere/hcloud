# frozen_string_literal: true

module HCloud
  class StorageBoxSnapshotStats < Entity
    attribute :size, :integer
    attribute :size_filesystem, :integer
  end
end
