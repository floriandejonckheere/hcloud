# frozen_string_literal: true

module HCloud
  class ResourceType
    class_attribute :resource_class_name

    attr_reader :array

    def initialize(array: false)
      @array = array
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def cast(value)
      case value
      when nil, []
        array? ? [] : nil
      when resource_class # Class
        value
      when Integer # ID
        resource_class.new(id: value)
      when String # Name
        resource_class.new(name: value)
      when Hash # Attribute hash
        resource_class.new(value)
      when Array # List
        value.map { |v| cast(v) }
      else
        raise ArgumentError, "cannot cast value: #{value} for type #{resource_class_name}"
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def resource_class
      @resource_class ||= resource_class_name.constantize
    end

    alias array? array

    def assert_valid_value(_); end

    # rubocop:disable Naming/MethodName
    def self.Type(class_name)
      Class
        .new(ResourceType) { self.resource_class_name = class_name }
        .tap { |klass| HCloud.const_set(:"#{class_name.demodulize}ResourceType", klass) }
    end
    # rubocop:enable Naming/MethodName
  end
end

ActiveModel::Type.register(:action, HCloud::ResourceType.Type("HCloud::Action"))
ActiveModel::Type.register(:amount, HCloud::ResourceType.Type("HCloud::Amount"))
ActiveModel::Type.register(:datacenter, HCloud::ResourceType.Type("HCloud::Datacenter"))
ActiveModel::Type.register(:datacenter_server_type, HCloud::ResourceType.Type("HCloud::DatacenterServerType"))
ActiveModel::Type.register(:dns_pointer, HCloud::ResourceType.Type("HCloud::DNSPointer"))
ActiveModel::Type.register(:error, HCloud::ResourceType.Type("HCloud::Error"))
ActiveModel::Type.register(:floating_ip, HCloud::ResourceType.Type("HCloud::FloatingIP"))
ActiveModel::Type.register(:image, HCloud::ResourceType.Type("HCloud::Image"))
ActiveModel::Type.register(:iso, HCloud::ResourceType.Type("HCloud::ISO"))
ActiveModel::Type.register(:location, HCloud::ResourceType.Type("HCloud::Location"))
ActiveModel::Type.register(:placement_group, HCloud::ResourceType.Type("HCloud::PlacementGroup"))
ActiveModel::Type.register(:price, HCloud::ResourceType.Type("HCloud::Price"))
ActiveModel::Type.register(:protection, HCloud::ResourceType.Type("HCloud::Protection"))
ActiveModel::Type.register(:server, HCloud::ResourceType.Type("HCloud::Server"))
ActiveModel::Type.register(:server_type, HCloud::ResourceType.Type("HCloud::ServerType"))
ActiveModel::Type.register(:ssh_key, HCloud::ResourceType.Type("HCloud::SSHKey"))
ActiveModel::Type.register(:volume, HCloud::ResourceType.Type("HCloud::Volume"))
