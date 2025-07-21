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
  #     HCloud::LoadBalancer.sort(name: :desc)
  #     # => [#<HCloud::LoadBalancer id: 1, ...>, ...]
  #
  #     HCloud::LoadBalancer.sort(:id, name: :asc)
  #     # => [#<HCloud::LoadBalancer id: 1, ...>, ...]
  #
  # == Search load balancers
  #
  #     HCloud::LoadBalancer.where(name: "my_load_balancer")
  #     # => #<HCloud::LoadBalancer id: 1, ...>
  #
  #     HCloud::LoadBalancer.where(label_selector: "environment=production")
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
  # = Actions
  # == List actions
  #
  #     actions = HCloud::LoadBalancer.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::LoadBalancer.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::LoadBalancer.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::LoadBalancer.find(1).actions.where(command: "add_service")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::LoadBalancer.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::LoadBalancer.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Resource-specific actions
  # == Add service
  #
  #     HCloud::LoadBalancer.find(1).add_service(destination_port: 80, health_check: { ... })
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Update service
  #
  #     HCloud::LoadBalancer.find(1).update_service(destination_port: 80, health_check: { ... })
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Delete service
  #
  #     HCloud::LoadBalancer.find(1).delete_service(listen_port: 4711)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Add target
  #
  #     HCloud::LoadBalancer.find(1).add_target(type: "server", ip: { ip: "203.0.113.1" })
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Remove target
  #
  #     HCloud::LoadBalancer.find(1).remove_target(type: "server", ip: { ip: "203.0.113.1" })
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Attach to network
  #
  #     HCloud::LoadBalancer.find(1).attach_to_network(ip: "10.0.1.1", network: 4711)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Detach from network
  #
  #     HCloud::LoadBalancer.find(1).detach_from_network(network: 4711)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change algorithm
  #
  #     HCloud::LoadBalancer.find(1).change_algorithm(type: "round_robin")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change DNS pointer
  #
  #     HCloud::LoadBalancer.find(1).change_dns_ptr(dns_ptr: "lb1.example.com", ip: "1.2.3.4")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change load balancer type
  #
  #     HCloud::LoadBalancer.find(1).change_type(load_balancer_type: "lb21")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change protection
  #
  #     HCloud::LoadBalancer.find(1).change_protection(delete: true)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Enable public interface
  #
  #     HCloud::LoadBalancer.find(1).enable_public_interface
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Disable public interface
  #
  #     HCloud::LoadBalancer.find(1).disable_public_interface
  #     # => #<HCloud::Action id: 1, ...>
  #
  class LoadBalancer < Resource
    actionable
    queryable
    creatable
    updatable
    deletable
    meterable
    labelable

    attribute :id, :integer
    attribute :name

    attribute :algorithm, :algorithm

    attribute :included_traffic, :integer
    attribute :ingoing_traffic, :integer
    attribute :outgoing_traffic, :integer

    attribute :load_balancer_type, :load_balancer_type

    attribute :location, :location

    # TODO: use only for creation
    attribute :network_zone
    # TODO: use only for creation
    attribute :network, :network
    # TODO: use only for creation
    attribute :public_interface, :boolean

    attribute :private_net, :load_balancer_private_net
    attribute :public_net, :load_balancer_public_net

    attribute :services, :service, array: true, default: -> { [] }
    attribute :targets, :target, array: true, default: -> { [] }

    attribute :protection, :protection

    action :add_service
    action :update_service
    action :delete_service

    action :add_target
    action :remove_target

    action :attach_to_network
    action :detach_from_network

    action :change_algorithm
    action :change_dns_ptr
    action :change_type

    action :change_protection

    action :enable_public_interface
    action :disable_public_interface

    def creatable_attributes
      [:name, :labels, :algorithm, :network_zone, :public_interface, :services, :targets, load_balancer_type: [:id, :name], location: [:id, :name], network: [:id, :name]]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
