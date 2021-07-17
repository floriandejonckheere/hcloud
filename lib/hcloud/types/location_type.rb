# frozen_string_literal: true

module HCloud
  class LocationType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| Location.new(v) }
      else
        Location.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:location, HCloud::LocationType)
