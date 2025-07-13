# frozen_string_literal: true

module HCloud
  class StorageBoxSnapshotPlan < Entity
    attribute :max_snapshots, :integer
    attribute :minute, :integer
    attribute :hour, :integer
    attribute :day_of_week, :integer
    attribute :day_of_month, :integer
  end
end
