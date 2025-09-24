# frozen_string_literal: true

module HCloud
  ##
  # Represents a server type
  #
  # == List all server types
  #
  #     HCloud::ServerType.all
  #     # => [#<HCloud::ServerType id: 1, ...>, ...]
  #
  # == Search server types
  #
  #     HCloud::ServerType.where(name: "cx11")
  #     # => #<HCloud::ServerType id: 1, ...>
  #
  # == Find server type by ID
  #
  #     HCloud::ServerType.find(1)
  #     # => #<HCloud::ServerType id: 1, ...>
  #
  class ServerType < Resource
    queryable

    attribute :id, :integer
    attribute :name
    attribute :description
    attribute :category

    attribute :architecture
    attribute :cores, :integer
    attribute :disk, :integer
    attribute :memory, :integer

    attribute :cpu_type
    attribute :storage_type

    attribute :prices, :price, array: true, default: -> { [] }

    attribute :locations, :server_type_location, array: true, default: -> { [] }

    attribute :deprecation, :deprecation, deprecated: true

    attribute :deprecated, :boolean, deprecated: true

    alias deprecated? deprecated
  end
end
