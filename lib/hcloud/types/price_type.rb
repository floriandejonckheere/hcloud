# frozen_string_literal: true

module HCloud
  class PriceType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| Price.new(v) }
      else
        Price.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:price, HCloud::PriceType)
