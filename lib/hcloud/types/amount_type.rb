# frozen_string_literal: true

module HCloud
  class AmountType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| Amount.new(v) }
      else
        Amount.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:amount, HCloud::AmountType)
