# frozen_string_literal: true

module HCloud
  module Prices
    class FloatingIPs < Entity
      attribute :type
      attribute :prices, :price
    end
  end
end
