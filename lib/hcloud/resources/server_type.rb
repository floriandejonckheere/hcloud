# frozen_string_literal: true

module HCloud
  class ServerType < Resource
    queryable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :cores, :integer
    attribute :disk, :integer
    attribute :memory, :integer

    attribute :cpu_type
    attribute :storage_type

    attribute :prices, :price, array: true

    attribute :deprecated, :boolean

    alias deprecated? deprecated
  end
end
