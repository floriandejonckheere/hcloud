# frozen_string_literal: true

module HCloud
  ##
  # Represents a network
  #
  # == List all networks
  #
  #     HCloud::Network.all
  #     # => [#<HCloud::Network id: 1, ...>, ...]
  #
  # == Search networks
  #
  #     HCloud::Network.all.where(name: "my_network")
  #     # => #<HCloud::Network id: 1, ...>
  #
  # == Find network by ID
  #
  #     HCloud::Network.find(1)
  #     # => #<HCloud::Network id: 1, ...>
  #
  # == Create network
  #
  #     network = HCloud::Network.new(name: "my_network", ip_range: "10.0.0.0/16")
  #     network.create
  #     network.created?
  #     # => true
  #
  #     network = HCloud::Network.create(name: "my_network", ip_range: "10.0.0.0/16")
  #     # => #<HCloud::Network id: 1, ...>
  #
  # == Update network
  #
  #     network = HCloud::Network.find(1)
  #     network.name = "another_network"
  #     network.update
  #
  # == Delete network
  #
  #     network = HCloud::Network.find(1)
  #     network.delete
  #     network.deleted?
  #     # => true
  #
  class Network < Resource
    actionable
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name

    attribute :ip_range

    attribute :routes, :route, array: true, default: -> { [] }
    attribute :subnets, :subnet, array: true, default: -> { [] }

    attribute :servers, :server, array: true, default: -> { [] }

    # TODO: load balancer resource
    attribute :load_balancers, array: true, default: -> { [] }

    attribute :protection, :protection

    attribute :labels, default: -> { {} }

    def creatable_attributes
      [:name, :labels, :ip_range, :routes, :subnets]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
