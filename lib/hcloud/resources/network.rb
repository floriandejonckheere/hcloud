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
  #     HCloud::Network.where(name: "my_network")
  #     # => #<HCloud::Network id: 1, ...>
  #
  #     HCloud::Network.where(label_selector: "environment=production")
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
  # = Actions
  # == List actions
  #
  #     actions = HCloud::Network.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::Network.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Network.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Network.find(1).actions.where(command: "assign_floating_ip")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Network.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::Network.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Resource-specific actions
  # == Change protection
  #
  #     HCloud::Network.find(1).change_protection(delete: true)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Add a route
  #
  #     HCloud::Network.find(1).add_route(destination: "10.100.1.0/24", gateway: "10.0.1.1")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Add a subnet
  #
  #     HCloud::Network.find(1).add_subnet(ip_range: "10.0.1.0/24", network_zone: "eu-central", type: "cloud")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change the IP range
  #
  #     HCloud::Network.find(1).change_ip_range(ip_range: "10.0.0.0/15")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Delete a route
  #
  #     HCloud::Network.find(1).delete_route(destination: "10.100.1.0/24", gateway: "10.0.1.1")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Delete a subnet
  #
  #     HCloud::Network.find(1).delete_subnet(ip_range: "10.0.1.0/24", network_zone: "eu-central", type: "cloud")
  #     # => #<HCloud::Action id: 1, ...>
  #
  class Network < Resource
    actionable
    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id, :integer
    attribute :name

    attribute :ip_range

    attribute :expose_routes_to_vswitch, :boolean

    attribute :routes, :route, array: true, default: -> { [] }
    attribute :subnets, :subnet, array: true, default: -> { [] }

    attribute :servers, :server, array: true, default: -> { [] }

    attribute :load_balancers, :load_balancer, array: true, default: -> { [] }

    attribute :protection, :protection

    action :change_protection

    action :add_route
    action :add_subnet
    action :change_ip_range
    action :delete_route
    action :delete_subnet

    def creatable_attributes
      [:name, :labels, :ip_range, :expose_routes_to_vswitch, :routes, :subnets]
    end

    def updatable_attributes
      [:name, :expose_routes_to_vswitch, :labels]
    end
  end
end