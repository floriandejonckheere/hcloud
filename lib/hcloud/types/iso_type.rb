# frozen_string_literal: true

module HCloud
  class ISOType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| ISO.new(v) }
      else
        ISO.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:iso, HCloud::ISOType)
