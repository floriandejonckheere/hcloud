# frozen_string_literal: true

module HCloud
  class DNSPointer < Entity
    attribute :dns_ptr
    attribute :ip
  end
end
