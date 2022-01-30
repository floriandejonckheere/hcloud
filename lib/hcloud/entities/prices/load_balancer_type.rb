# frozen_string_literal: true

module HCloud
  module Prices
    class LoadBalancerType < Entity
      attribute :id, :integer
      attribute :name
      attribute :prices, :price, array: true, default: -> { [] }
    end
  end
end
