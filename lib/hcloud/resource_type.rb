# frozen_string_literal: true

module HCloud
  class ResourceType < ActiveModel::Type::Value
    class_attribute :class_name

    def initialize(...)
      super()
    end

    def cast(value)
      case value
      when klass
        value
      when Array
        value.map { |v| klass.new(v) }
      else
        klass.new(value)
      end
    end

    def klass
      @klass ||= class_name.constantize
    end

    # rubocop:disable Naming/MethodName
    def self.Type(class_name)
      Class.new(ResourceType) do
        self.class_name = class_name
      end
    end
    # rubocop:enable Naming/MethodName
  end
end

ActiveModel::Type.register(:amount, HCloud::ResourceType.Type("HCloud::Amount"))
ActiveModel::Type.register(:datacenter, HCloud::ResourceType.Type("HCloud::Datacenter"))
ActiveModel::Type.register(:datacenter_server_type, HCloud::ResourceType.Type("HCloud::DatacenterServerType"))
ActiveModel::Type.register(:iso, HCloud::ResourceType.Type("HCloud::ISO"))
ActiveModel::Type.register(:location, HCloud::ResourceType.Type("HCloud::Location"))
ActiveModel::Type.register(:price, HCloud::ResourceType.Type("HCloud::Price"))
ActiveModel::Type.register(:protection, HCloud::ResourceType.Type("HCloud::Protection"))
ActiveModel::Type.register(:server_type, HCloud::ResourceType.Type("HCloud::ServerType"))
