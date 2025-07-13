# frozen_string_literal: true

module HCloud
  class StorageBoxStats < Entity
    attribute :size, :integer
    attribute :size_data, :integer
    attribute :size_snapshots, :integer
  end
end
