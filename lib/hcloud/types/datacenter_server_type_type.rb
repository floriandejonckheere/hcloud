# frozen_string_literal: true

module HCloud
  class DatacenterServerTypeType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| DatacenterServerType.new(v) }
      else
        DatacenterServerType.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:datacenter_server_type, HCloud::DatacenterServerTypeType)
