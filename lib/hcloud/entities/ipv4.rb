# frozen_string_literal: true

module HCloud
  class IPv4 < Entity
    attribute :blocked, :boolean
    attribute :dns_ptr
    attribute :id, :integer
    attribute :ip

    alias blocked? blocked
  end
end
