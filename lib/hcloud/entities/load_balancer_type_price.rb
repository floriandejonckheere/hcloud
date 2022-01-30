# frozen_string_literal: true

module HCloud
  class LoadBalancerTypePrice < Entity
    attribute :id, :integer
    attribute :name
    attribute :prices, :price, array: true, default: -> { [] }
  end
end
