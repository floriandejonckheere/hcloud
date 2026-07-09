# frozen_string_literal: true

module HCloud
  class PublicNet < Entity
    attribute :firewalls, :public_net_firewall, array: true, default: -> { [] }
    attribute :floating_ips, :floating_ip, array: true, default: -> { [] }
    attribute :ipv4, :ipv4
    attribute :ipv6, :ipv6

    attribute :enable_ipv4, :boolean
    attribute :enable_ipv6, :boolean

    def to_h
      {
        enable_ipv4: enable_ipv4,
        enable_ipv6: enable_ipv6,
        ipv4: ipv4&.id,
        ipv6: ipv6&.id,
      }.compact
    end
  end
end
