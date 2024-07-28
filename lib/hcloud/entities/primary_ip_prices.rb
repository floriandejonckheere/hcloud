# frozen_string_literal: true

module HCloud
  class PrimaryIPPrices < Entity
    attribute :type
    attribute :prices, :price, array: true, default: -> { [] }
  end
end
