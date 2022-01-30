# frozen_string_literal: true

module HCloud
  module Prices
    class FloatingIP < Entity
      attribute :price_monthly, :amount
    end
  end
end
