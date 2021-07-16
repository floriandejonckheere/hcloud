# frozen_string_literal: true

module HCloud
  class PriceType < ActiveModel::Type::Value
    def cast(value)
      Price.new(value)
    end
  end
end

ActiveModel::Type.register(:price, HCloud::PriceType)
