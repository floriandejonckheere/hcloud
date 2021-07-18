# frozen_string_literal: true

module HCloud
  class DatacenterType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| Datacenter.new(v) }
      else
        Datacenter.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:datacenter, HCloud::DatacenterType)
