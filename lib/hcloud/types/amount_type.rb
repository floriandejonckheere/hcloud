# frozen_string_literal: true

module HCloud
  class AmountType < ActiveModel::Type::Value
    def cast(value)
      Amount.new(value)
    end
  end
end

ActiveModel::Type.register(:amount, HCloud::AmountType)
