# frozen_string_literal: true

module HCloud
  module Prices
    class Volume < Entity
      attribute :price_per_gb_month, :amount
    end
  end
end
