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
    # Limitation: resource types cannot be nested, because the types
    # are registered as soon as possible, and the modules may not exist yet.
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
ActiveModel::Type.register(:applied_to, HCloud::ResourceType.Type("HCloud::AppliedTo"))
ActiveModel::Type.register(:applied_to_resource, HCloud::ResourceType.Type("HCloud::AppliedToResource"))
ActiveModel::Type.register(:apply_to, HCloud::ResourceType.Type("HCloud::ApplyTo"))
ActiveModel::Type.register(:datacenter, HCloud::ResourceType.Type("HCloud::Datacenter"))
ActiveModel::Type.register(:datacenter_server_type, HCloud::ResourceType.Type("HCloud::DatacenterServerType"))
ActiveModel::Type.register(:dns_pointer, HCloud::ResourceType.Type("HCloud::DNSPointer"))
ActiveModel::Type.register(:error, HCloud::ResourceType.Type("HCloud::Error"))
ActiveModel::Type.register(:firewall, HCloud::ResourceType.Type("HCloud::Firewall"))
ActiveModel::Type.register(:floating_ip, HCloud::ResourceType.Type("HCloud::FloatingIP"))
ActiveModel::Type.register(:floating_ip_price, HCloud::ResourceType.Type("HCloud::FloatingIPPrice"))
ActiveModel::Type.register(:floating_ip_prices, HCloud::ResourceType.Type("HCloud::FloatingIPPrices"))
ActiveModel::Type.register(:image, HCloud::ResourceType.Type("HCloud::Image"))
ActiveModel::Type.register(:image_price, HCloud::ResourceType.Type("HCloud::ImagePrice"))
ActiveModel::Type.register(:ipv4, HCloud::ResourceType.Type("HCloud::IPv4"))
ActiveModel::Type.register(:ipv6, HCloud::ResourceType.Type("HCloud::IPv6"))
ActiveModel::Type.register(:iso, HCloud::ResourceType.Type("HCloud::ISO"))
ActiveModel::Type.register(:load_balancer_type_price, HCloud::ResourceType.Type("HCloud::LoadBalancerTypePrice"))
ActiveModel::Type.register(:location, HCloud::ResourceType.Type("HCloud::Location"))
ActiveModel::Type.register(:network, HCloud::ResourceType.Type("HCloud::Network"))
ActiveModel::Type.register(:placement_group, HCloud::ResourceType.Type("HCloud::PlacementGroup"))
ActiveModel::Type.register(:price, HCloud::ResourceType.Type("HCloud::Price"))
ActiveModel::Type.register(:private_net, HCloud::ResourceType.Type("HCloud::PrivateNet"))
ActiveModel::Type.register(:protection, HCloud::ResourceType.Type("HCloud::Protection"))
ActiveModel::Type.register(:public_net, HCloud::ResourceType.Type("HCloud::PublicNet"))
ActiveModel::Type.register(:route, HCloud::ResourceType.Type("HCloud::Route"))
ActiveModel::Type.register(:rule, HCloud::ResourceType.Type("HCloud::Rule"))
ActiveModel::Type.register(:server, HCloud::ResourceType.Type("HCloud::Server"))
ActiveModel::Type.register(:server_backup_price, HCloud::ResourceType.Type("HCloud::ServerBackupPrice"))
ActiveModel::Type.register(:server_type, HCloud::ResourceType.Type("HCloud::ServerType"))
ActiveModel::Type.register(:server_type_price, HCloud::ResourceType.Type("HCloud::ServerTypePrice"))
ActiveModel::Type.register(:ssh_key, HCloud::ResourceType.Type("HCloud::SSHKey"))
ActiveModel::Type.register(:subnet, HCloud::ResourceType.Type("HCloud::Subnet"))
ActiveModel::Type.register(:traffic_price, HCloud::ResourceType.Type("HCloud::TrafficPrice"))
ActiveModel::Type.register(:volume, HCloud::ResourceType.Type("HCloud::Volume"))
ActiveModel::Type.register(:volume_price, HCloud::ResourceType.Type("HCloud::VolumePrice"))
