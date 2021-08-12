# frozen_string_literal: true

module HCloud
  class ResourceType < ActiveModel::Type::Value
    class_attribute :class_name

    def initialize(...)
      super()
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def cast(value)
      return if value.blank?

      case value
      when klass # Class
        value
      when Integer # ID
        klass.new(id: value)
      when String # Name
        klass.new(name: value)
      when Array # List
        value.map { |v| cast(v) }
      when Hash # Attribute hash
        klass.new(value)
      else
        raise ArgumentError, "cannot cast value: #{value} for type #{class_name}"
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def klass
      @klass ||= class_name.constantize
    end

    # rubocop:disable Naming/MethodName
    def self.Type(class_name)
      Class
        .new(ResourceType) { self.class_name = class_name }
        .tap { |klass| HCloud.const_set(:"#{class_name.demodulize}Type", klass) }
    end
    # rubocop:enable Naming/MethodName
  end
end

ActiveModel::Type.register(:amount, HCloud::ResourceType.Type("HCloud::Amount"))
ActiveModel::Type.register(:datacenter, HCloud::ResourceType.Type("HCloud::Datacenter"))
ActiveModel::Type.register(:datacenter_server_type, HCloud::ResourceType.Type("HCloud::DatacenterServerType"))
ActiveModel::Type.register(:dns_pointer, HCloud::ResourceType.Type("HCloud::DNSPointer"))
ActiveModel::Type.register(:error, HCloud::ResourceType.Type("HCloud::Error"))
ActiveModel::Type.register(:image, HCloud::ResourceType.Type("HCloud::Image"))
ActiveModel::Type.register(:iso, HCloud::ResourceType.Type("HCloud::ISO"))
ActiveModel::Type.register(:location, HCloud::ResourceType.Type("HCloud::Location"))
ActiveModel::Type.register(:price, HCloud::ResourceType.Type("HCloud::Price"))
ActiveModel::Type.register(:protection, HCloud::ResourceType.Type("HCloud::Protection"))
ActiveModel::Type.register(:server_type, HCloud::ResourceType.Type("HCloud::ServerType"))
ActiveModel::Type.register(:ssh_key, HCloud::ResourceType.Type("HCloud::SSHKey"))
ActiveModel::Type.register(:volume, HCloud::ResourceType.Type("HCloud::Volume"))
