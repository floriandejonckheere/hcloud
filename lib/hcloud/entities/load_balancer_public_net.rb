# frozen_string_literal: true

module HCloud
  class LoadBalancerPublicNet < Entity
    attribute :enabled, :boolean
    attribute :ipv4, :load_balancer_public_net_ip
    attribute :ipv6, :load_balancer_public_net_ip

    alias enabled? enabled

    def to_h
      {
        ipv4: ipv4&.id,
        ipv6: ipv6&.id,
      }.compact
    end
  end
end
