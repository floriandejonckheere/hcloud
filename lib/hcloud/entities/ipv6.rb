# frozen_string_literal: true

module HCloud
  class IPv6 < Entity
    attribute :blocked, :boolean
    attribute :dns_ptr, :dns_pointer, array: true, default: -> { [] }
    attribute :id, :integer
    attribute :ip

    alias blocked? blocked
  end
end
