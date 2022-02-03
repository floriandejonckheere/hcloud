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
  #     load_balancer = HCloud::LoadBalancer.new(name: "my_load_balancer", algorithm: { type: "round_robin" }, load_balancer_type: "lb11", location: "nbg1")
  #     load_balancer.create
  #     load_balancer.created?
  #     # => true
  #
  #     load_balancer = HCloud::LoadBalancer.create(name: "my_load_balancer", algorithm: { type: "round_robin" }, load_balancer_type: "lb11", location: "nbg1")
  #     # => #<HCloud::LoadBalancer id: 1, ...>
  #
  # == Update load balancer
  #
  #     load_balancer = HCloud::LoadBalancer.find(1)
  #     load_balancer.name = "another_load_balancer"
  #     load_balancer.update
  #
  # == Delete load balancer
  #
  #     load_balancer = HCloud::LoadBalancer.find(1)
  #     load_balancer.delete
  #     load_balancer.deleted?
  #     # => true
  #
  # == Get metrics
  #
  #     load_balancer = HCloud::LoadBalancer.find(1)
  #     load_balancer.metrics(type: :bandwidth, from: 2.minutes.ago, to: 1.minute.ago)
  #     # => #<HCloud::Metrics ...>
  #
  #     load_balancer.metrics(type: [:connections_per_second, :requests_per_second], from: 2.minutes.ago, to: 1.minute.ago, step: 60)
  #     # => #<HCloud::Metrics ...>
  #
  class LoadBalancer < Resource
    queryable
    creatable
    updatable
    deletable
    meterable

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
