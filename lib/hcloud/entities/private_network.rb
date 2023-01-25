# frozen_string_literal: true

module HCloud
  class PrivateNetwork < Entity
    attribute :ip
    attribute :alias_ips, array: true, default: -> { [] }
    attribute :interface_num, :integer
    attribute :mac_address
    attribute :network_id, :integer
    attribute :network_name
    attribute :network
    attribute :subnet
    attribute :gateway
  end
end
