# frozen_string_literal: true

module HCloud
  class Price < Entity
    attribute :location
    attribute :price_hourly, :amount
    attribute :price_monthly, :amount
  end
end
