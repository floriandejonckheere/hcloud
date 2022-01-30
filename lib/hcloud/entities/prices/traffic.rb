# frozen_string_literal: true

module HCloud
  module Prices
    class Traffic < Entity
      attribute :price_per_tb, :amount
    end
  end
end
