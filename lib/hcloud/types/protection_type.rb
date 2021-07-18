# frozen_string_literal: true

module HCloud
  class ProtectionType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| Protection.new(v) }
      else
        Protection.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:protection, HCloud::ProtectionType)
