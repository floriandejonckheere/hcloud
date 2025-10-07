# frozen_string_literal: true

# rubocop:disable Metrics/CyclomaticComplexity
module HCloud
  # @!visibility private
  class ResourceType
    class_attribute :resource_class_name

    attr_reader :array

    def initialize(array: false)
      @array = array
    end

    def mutable?
      true
    end

    def cast(value)
      case value
      when nil, []
        array? ? [] : nil
      when resource_class # Class
        value
      when Integer # ID
        resource_class.new(id: value)
      when String # Name or Type
        if resource_class.attribute_names.include?("name")
          resource_class.new(name: value)
        else
          resource_class.new(type: value)
        end
      when Hash # Attribute hash
        resource_class.new(value)
      when Array # List
        raise ArgumentError, "cannot cast value: #{value} for type #{resource_class_name}" unless array?

        value.map { |v| cast(v) }
      else
        raise ArgumentError, "cannot cast value: #{value} for type #{resource_class_name}"
      end
    end

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

    # @!visibility private
    class GenericType < ResourceType
      def cast(value)
        case value
        when nil, []
          array? ? [] : nil
        when HCloud::Resource # Class
          value
        when Hash # Attribute hash
          ActiveModel::Type
            .lookup(value.fetch(:type).to_sym)
            .cast(value.except(:type))
        when Array # List
          raise ArgumentError, "cannot cast value: #{value} for generic type" unless array?

          value.map { |v| cast(v) }
        else
          raise ArgumentError, "cannot cast value: #{value} for generic type"
        end
      rescue KeyError => e
        raise ArgumentError, "cannot cast value: #{value} for generic type: #{e.message}"
      end
    end
  end
end
# rubocop:enable Metrics/CyclomaticComplexity

ActiveModel::Type.register(:action, HCloud::ResourceType.Type("HCloud::Action"))
ActiveModel::Type.register(:algorithm, HCloud::ResourceType.Type("HCloud::Algorithm"))
ActiveModel::Type.register(:amount, HCloud::ResourceType.Type("HCloud::Amount"))
ActiveModel::Type.register(:applied_to, HCloud::ResourceType.Type("HCloud::AppliedTo"))
ActiveModel::Type.register(:applied_to_resource, HCloud::ResourceType.Type("HCloud::AppliedToResource"))
ActiveModel::Type.register(:apply_to, HCloud::ResourceType.Type("HCloud::ApplyTo"))
ActiveModel::Type.register(:authoritative_nameservers, HCloud::ResourceType.Type("HCloud::AuthoritativeNameservers"))
ActiveModel::Type.register(:certificate, HCloud::ResourceType.Type("HCloud::Certificate"))
ActiveModel::Type.register(:certificate_status, HCloud::ResourceType.Type("HCloud::CertificateStatus"))
ActiveModel::Type.register(:datacenter, HCloud::ResourceType.Type("HCloud::Datacenter"))
ActiveModel::Type.register(:datacenter_server_type, HCloud::ResourceType.Type("HCloud::DatacenterServerType"))
ActiveModel::Type.register(:deprecation, HCloud::ResourceType.Type("HCloud::Deprecation"))
ActiveModel::Type.register(:dns_pointer, HCloud::ResourceType.Type("HCloud::DNSPointer"))
ActiveModel::Type.register(:error, HCloud::ResourceType.Type("HCloud::Error"))
ActiveModel::Type.register(:firewall, HCloud::ResourceType.Type("HCloud::Firewall"))
ActiveModel::Type.register(:floating_ip, HCloud::ResourceType.Type("HCloud::FloatingIP"))
ActiveModel::Type.register(:floating_ip_price, HCloud::ResourceType.Type("HCloud::FloatingIPPrice"))
ActiveModel::Type.register(:floating_ip_prices, HCloud::ResourceType.Type("HCloud::FloatingIPPrices"))
ActiveModel::Type.register(:health_check, HCloud::ResourceType.Type("HCloud::HealthCheck"))
ActiveModel::Type.register(:health_check_http, HCloud::ResourceType.Type("HCloud::HealthCheckHTTP"))
ActiveModel::Type.register(:health_status, HCloud::ResourceType.Type("HCloud::HealthStatus"))
ActiveModel::Type.register(:image, HCloud::ResourceType.Type("HCloud::Image"))
ActiveModel::Type.register(:image_price, HCloud::ResourceType.Type("HCloud::ImagePrice"))
ActiveModel::Type.register(:ipv4, HCloud::ResourceType.Type("HCloud::IPv4"))
ActiveModel::Type.register(:ipv6, HCloud::ResourceType.Type("HCloud::IPv6"))
ActiveModel::Type.register(:iso, HCloud::ResourceType.Type("HCloud::ISO"))
ActiveModel::Type.register(:label_selector, HCloud::ResourceType.Type("HCloud::LabelSelector"))
ActiveModel::Type.register(:load_balancer, HCloud::ResourceType.Type("HCloud::LoadBalancer"))
ActiveModel::Type.register(:load_balancer_private_net, HCloud::ResourceType.Type("HCloud::LoadBalancerPrivateNet"))
ActiveModel::Type.register(:load_balancer_public_net, HCloud::ResourceType.Type("HCloud::LoadBalancerPublicNet"))
ActiveModel::Type.register(:load_balancer_type, HCloud::ResourceType.Type("HCloud::LoadBalancerType"))
ActiveModel::Type.register(:load_balancer_type_price, HCloud::ResourceType.Type("HCloud::LoadBalancerTypePrice"))
ActiveModel::Type.register(:location, HCloud::ResourceType.Type("HCloud::Location"))
ActiveModel::Type.register(:metadata, HCloud::ResourceType.Type("HCloud::Metadata"))
ActiveModel::Type.register(:nameserver, HCloud::ResourceType.Type("HCloud::Nameserver"))
ActiveModel::Type.register(:network, HCloud::ResourceType.Type("HCloud::Network"))
ActiveModel::Type.register(:placement_group, HCloud::ResourceType.Type("HCloud::PlacementGroup"))
ActiveModel::Type.register(:price, HCloud::ResourceType.Type("HCloud::Price"))
ActiveModel::Type.register(:pricing, HCloud::ResourceType.Type("HCloud::Pricing"))
ActiveModel::Type.register(:primary_ip, HCloud::ResourceType.Type("HCloud::PrimaryIP"))
ActiveModel::Type.register(:primary_ip_prices, HCloud::ResourceType.Type("HCloud::PrimaryIPPrices"))
ActiveModel::Type.register(:private_net, HCloud::ResourceType.Type("HCloud::PrivateNet"))
ActiveModel::Type.register(:private_network, HCloud::ResourceType.Type("HCloud::PrivateNetwork"))
ActiveModel::Type.register(:protection, HCloud::ResourceType.Type("HCloud::Protection"))
ActiveModel::Type.register(:public_net, HCloud::ResourceType.Type("HCloud::PublicNet"))
ActiveModel::Type.register(:public_net_firewall, HCloud::ResourceType.Type("HCloud::PublicNetFirewall"))
ActiveModel::Type.register(:resource, HCloud::ResourceType::GenericType)
ActiveModel::Type.register(:route, HCloud::ResourceType.Type("HCloud::Route"))
ActiveModel::Type.register(:rule, HCloud::ResourceType.Type("HCloud::Rule"))
ActiveModel::Type.register(:server, HCloud::ResourceType.Type("HCloud::Server"))
ActiveModel::Type.register(:server_backup_price, HCloud::ResourceType.Type("HCloud::ServerBackupPrice"))
ActiveModel::Type.register(:server_protection, HCloud::ResourceType.Type("HCloud::ServerProtection"))
ActiveModel::Type.register(:server_type, HCloud::ResourceType.Type("HCloud::ServerType"))
ActiveModel::Type.register(:server_type_location, HCloud::ResourceType.Type("HCloud::ServerTypeLocation"))
ActiveModel::Type.register(:server_type_price, HCloud::ResourceType.Type("HCloud::ServerTypePrice"))
ActiveModel::Type.register(:service, HCloud::ResourceType.Type("HCloud::Service"))
ActiveModel::Type.register(:service_http, HCloud::ResourceType.Type("HCloud::ServiceHTTP"))
ActiveModel::Type.register(:ssh_key, HCloud::ResourceType.Type("HCloud::SSHKey"))
ActiveModel::Type.register(:storage_box, HCloud::ResourceType.Type("HCloud::StorageBox"))
ActiveModel::Type.register(:storage_box_access_settings, HCloud::ResourceType.Type("HCloud::StorageBoxAccessSettings"))
ActiveModel::Type.register(:storage_box_price, HCloud::ResourceType.Type("HCloud::StorageBoxPrice"))
ActiveModel::Type.register(:storage_box_snapshot_plan, HCloud::ResourceType.Type("HCloud::StorageBoxSnapshotPlan"))
ActiveModel::Type.register(:storage_box_stats, HCloud::ResourceType.Type("HCloud::StorageBoxStats"))
ActiveModel::Type.register(:storage_box_type, HCloud::ResourceType.Type("HCloud::StorageBoxType"))
ActiveModel::Type.register(:storage_box_snapshot, HCloud::ResourceType.Type("HCloud::StorageBoxSnapshot"))
ActiveModel::Type.register(:storage_box_snapshot_stats, HCloud::ResourceType.Type("HCloud::StorageBoxSnapshotStats"))
ActiveModel::Type.register(:storage_box_subaccount, HCloud::ResourceType.Type("HCloud::StorageBoxSubaccount"))
ActiveModel::Type.register(:storage_box_subaccount_access_settings, HCloud::ResourceType.Type("HCloud::StorageBoxSubaccountAccessSettings"))
ActiveModel::Type.register(:subnet, HCloud::ResourceType.Type("HCloud::Subnet"))
ActiveModel::Type.register(:target, HCloud::ResourceType.Type("HCloud::Target"))
ActiveModel::Type.register(:targets, HCloud::ResourceType.Type("HCloud::Targets"))
ActiveModel::Type.register(:target_ip, HCloud::ResourceType.Type("HCloud::TargetIP"))
ActiveModel::Type.register(:traffic_price, HCloud::ResourceType.Type("HCloud::TrafficPrice"))
ActiveModel::Type.register(:used_by, HCloud::ResourceType.Type("HCloud::UsedBy"))
ActiveModel::Type.register(:volume, HCloud::ResourceType.Type("HCloud::Volume"))
ActiveModel::Type.register(:volume_price, HCloud::ResourceType.Type("HCloud::VolumePrice"))
ActiveModel::Type.register(:zone, HCloud::ResourceType.Type("HCloud::Zone"))
