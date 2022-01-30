# frozen_string_literal: true

module HCloud
  class PrivateNet < Entity
    attribute :alias_ips, array: true, default: -> { [] }
    attribute :ip
    attribute :mac_address
    attribute :network, :network
  end
end
