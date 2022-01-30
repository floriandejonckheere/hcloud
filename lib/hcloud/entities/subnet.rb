# frozen_string_literal: true

module HCloud
  class Subnet < Entity
    attribute :type
    attribute :network_zone
    attribute :gateway
    attribute :ip_range
    attribute :vswitch_id
  end
end
