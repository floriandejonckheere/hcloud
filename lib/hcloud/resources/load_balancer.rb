# frozen_string_literal: true

module HCloud
  ##
  # Represents a load balancer
  #
  # == List all load balancers
  #
  #     HCloud::LoadBalancer.all
  #     # => [#<HCloud::LoadBalancer id: 1, ...>, ...]
  #
  # == Sort load balancers
  #
  #     HCloud::LoadBalancer.all.sort(name: :desc)
  #     # => [#<HCloud::LoadBalancer id: 1, ...>, ...]
  #
  #     HCloud::LoadBalancer.all.sort(:id, name: :asc)
  #     # => [#<HCloud::LoadBalancer id: 1, ...>, ...]
  #
  # == Search load balancers
  #
  #     HCloud::LoadBalancer.all.where(name: "my_load_balancer")
  #     # => #<HCloud::LoadBalancer id: 1, ...>
  #
  # == Find load balancer by ID
  #
  #     HCloud::LoadBalancer.find(1)
  #     # => #<HCloud::LoadBalancer id: 1, ...>
  #
  # == Create load balancer
  #
  #     load balancer = HCloud::LoadBalancer.new(name: "my_load_balancer", algorithm: { type: "round_robin" }, load_balancer_type: "lb11", location: "nbg1")
  #     load balancer.create
  #     load balancer.created?
  #     # => true
  #
  #     load balancer = HCloud::LoadBalancer.create(name: "my_load_balancer", algorithm: { type: "round_robin" }, load_balancer_type: "lb11", location: "nbg1")
  #     # => #<HCloud::LoadBalancer id: 1, ...>
  #
  # == Update load balancer
  #
  #     load balancer = HCloud::LoadBalancer.find(1)
  #     load balancer.name = "another_load balancer"
  #     load balancer.update
  #
  # == Delete load balancer
  #
  #     load balancer = HCloud::LoadBalancer.find(1)
  #     load balancer.delete
  #     load balancer.deleted?
  #     # => true
  #
  class LoadBalancer < Resource
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name

    attribute :algorithm, :algorithm

    attribute :included_traffic, :integer
    attribute :ingoing_traffic, :integer
    attribute :outgoing_traffic, :integer

    attribute :load_balancer_type, :load_balancer_type

    attribute :location, :location

    # Only used for creation
    attribute :network_zone
    # Only used for creation
    attribute :network, :network
    # Only used for creation
    attribute :public_interface, :boolean

    attribute :private_net, :load_balancer_private_net
    attribute :public_net, :load_balancer_public_net

    attribute :services, :service, array: true, default: -> { [] }
    attribute :targets, :target, array: true, default: -> { [] }

    attribute :protection, :protection

    attribute :labels, default: -> { {} }

    def creatable_attributes
      [:name, :labels, :algorithm, :network_zone, :public_interface, :services, :targets, load_balancer_type: [:id, :name], location: [:id, :name], network: [:id, :name]]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
