# frozen_string_literal: true

module HCloud
  ##
  # Represents a load balancer type
  #
  # == List all load balancer types
  #
  #     HCloud::LoadBalancerType.all
  #     # => [#<HCloud::LoadBalancerType id: 1, ...>, ...]
  #
  # == Search load balancer types
  #
  #     HCloud::LoadBalancerType.where(name: "cx11")
  #     # => #<HCloud::LoadBalancerType id: 1, ...>
  #
  # == Find load balancer type by ID
  #
  #     HCloud::LoadBalancerType.find(1)
  #     # => #<HCloud::LoadBalancerType id: 1, ...>
  #
  class LoadBalancerType < Resource
    queryable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :max_assigned_certificates, :integer
    attribute :max_connections, :integer
    attribute :max_services, :integer
    attribute :max_targets, :integer

    attribute :prices, :price, array: true, default: -> { [] }

    attribute :deprecated, :datetime
  end
end
