# frozen_string_literal: true

module HCloud
  class LoadBalancerPublicNet < Entity
    attribute :enabled, :boolean
    attribute :ipv4, :dns_pointer
    attribute :ipv6, :dns_pointer

    alias enabled? enabled
  end
end
