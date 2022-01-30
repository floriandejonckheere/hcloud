# frozen_string_literal: true

module HCloud
  class VolumePrice < Entity
    attribute :price_per_gb_month, :amount
  end
end
