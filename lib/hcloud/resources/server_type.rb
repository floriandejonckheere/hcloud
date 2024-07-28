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

    attribute :architecture
    attribute :cores, :integer
    attribute :disk, :integer
    attribute :memory, :integer
    attribute :included_traffic, :integer

    attribute :cpu_type
    attribute :storage_type

    attribute :prices, :price, array: true, default: -> { [] }

    attribute :deprecated, :boolean
    attribute :deprecation, :deprecation

    def included_traffic
      # FIXME: Attribute will return null on 2024-08-05
      # FIXME: Attribute will be removed on 2024-11-05
      warn "[DEPRECATION] Field \"included_traffic\" on server types is deprecated."

      super
    end

    def deprecated
      warn "[DEPRECATION] Field \"deprecated\" on server types is deprecated."

      super
    end

    alias deprecated? deprecated
  end
end
