# frozen_string_literal: true

module HCloud
  class StorageBoxPrice < Entity
    attribute :location
    attribute :price_hourly, :amount
    attribute :price_monthly, :amount
    attribute :setup_fee, :amount
  end
end
