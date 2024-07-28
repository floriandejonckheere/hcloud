# frozen_string_literal: true

module HCloud
  class Price < Entity
    attribute :included_traffic, :integer
    attribute :location
    attribute :price_hourly, :amount
    attribute :price_monthly, :amount
    attribute :price_per_tb_traffic, :amount
  end
end
