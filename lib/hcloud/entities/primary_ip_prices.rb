# frozen_string_literal: true

module HCloud
  class PrimaryIPPrices < Entity
    attribute :type
    attribute :prices, :price
  end
end
