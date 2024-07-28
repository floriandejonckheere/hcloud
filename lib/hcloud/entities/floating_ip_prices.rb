# frozen_string_literal: true

module HCloud
  class FloatingIPPrices < Entity
    attribute :type
    attribute :prices, :price, array: true, default: -> { [] }
  end
end
