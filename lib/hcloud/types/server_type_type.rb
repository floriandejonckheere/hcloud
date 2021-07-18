# frozen_string_literal: true

module HCloud
  class ServerTypeType < ActiveModel::Type::Value
    def initialize(...)
      super()
    end

    def cast(value)
      if value.is_a? Array
        value.map { |v| ServerType.new(v) }
      else
        ServerType.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:server_type, HCloud::ServerTypeType)
