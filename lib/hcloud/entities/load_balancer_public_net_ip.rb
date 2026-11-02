# frozen_string_literal: true

module HCloud
  class LoadBalancerPublicNetIP < Entity
    attribute :id, :integer
    attribute :ip
    attribute :dns_ptr

    attribute :blocked, :boolean

    alias blocked? blocked
  end
end
