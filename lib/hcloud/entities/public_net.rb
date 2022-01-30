# frozen_string_literal: true

module HCloud
  class PublicNet < Entity
    attribute :firewalls, :firewall, array: true, default: -> { [] }
    attribute :floating_ips, :floating_ip, array: true, default: -> { [] }
    attribute :ipv4, :ipv4
    attribute :ipv6, :ipv6
  end
end
