# frozen_string_literal: true

module HCloud
  ##
  # Represents a server
  #
  # == List all servers
  #
  #     HCloud::Server.all
  #     # => [#<HCloud::Server id: 1, ...>, ...]
  #
  # == Sort servers
  #
  #     HCloud::Server.sort(name: :desc)
  #     # => [#<HCloud::Server id: 1, ...>, ...]
  #
  #     HCloud::Server.sort(:id, name: :asc)
  #     # => [#<HCloud::Server id: 1, ...>, ...]
  #
  # == Search servers
  #
  #     HCloud::Server.where(name: "my_server")
  #     # => #<HCloud::Server id: 1, ...>
  #
  #     HCloud::Server.where(status: "running")
  #     # => #<HCloud::Server id: 1, ...>
  #
  #     HCloud::Server.where(label_selector: "environment=production")
  #     # => #<HCloud::Server id: 1, ...>
  #
  # == Find server by ID
  #
  #     HCloud::Server.find(1)
  #     # => #<HCloud::Server id: 1, ...>
  #
  # == Create server
  #
  #     user_data = File.read("user_data.yml")
  #     server = HCloud::Server.new(name: "my_server", image: "debian-11", server_type: "cx11", user_data: user_data)
  #     server.create
  #     server.created?
  #     # => true
  #
  #     firewall = HCloud::Server.create(name: "my_server", image: "debian-11", server_type: "cx11")
  #     # => #<HCloud::Server id: 1, ...>
  #
  # == Update server
  #
  #     server = HCloud::Server.find(1)
  #     server.name = "another_server"
  #     server.update
  #
  # == Delete server
  #
  #     server = HCloud::Server.find(1)
  #     server.delete
  #     server.deleted?
  #     # => true
  #
  # == Get metrics
  #
  #     server = HCloud::Server.find(1)
  #     server.metrics(type: :cpu, from: 2.minutes.ago, to: 1.minute.ago)
  #     # => #<HCloud::Metrics ...>
  #
  #     server.metrics(type: [:cpu, :disk, :network], from: 2.minutes.ago, to: 1.minute.ago, step: 60)
  #     # => #<HCloud::Metrics ...>
  #
  # TODO: actions
  #
  class Server < Resource
    actionable
    queryable
    creatable
    updatable
    deletable
    meterable
    labelable

    attribute :id, :integer
    attribute :name

    attribute :server_type, :server_type

    attribute :status

    attribute :backup_window

    # TODO: use only for creation
    attribute :user_data

    # TODO: use only for creation
    attribute :location, :location

    # TODO: use only for creation
    attribute :ssh_keys, :ssh_key, array: true, default: -> { [] }

    # TODO: use only for creation
    attribute :firewalls, array: true, default: -> { [] }

    # TODO: use only for creation
    attribute :networks, array: true, default: -> { [] }

    attribute :root_password

    attribute :datacenter, :datacenter

    attribute :included_traffic, :integer
    attribute :ingoing_traffic, :integer
    attribute :outgoing_traffic, :integer

    attribute :primary_disk_size, :integer

    attribute :protection, :server_protection

    attribute :image, :image

    attribute :public_net, :public_net
    attribute :private_net, :private_net, array: true, default: -> { [] }

    attribute :placement_group, :placement_group

    attribute :iso, :iso

    attribute :load_balancers, :load_balancer, array: true, default: -> { [] }

    attribute :volumes, :volume, array: true, default: -> { [] }

    attribute :locked, :boolean
    attribute :rescue_enabled, :boolean

    alias rescue_enabled? rescue_enabled

    alias locked? locked

    action :add_to_placement_group
    action :remove_from_placement_group

    action :attach_iso
    action :detach_iso

    action :attach_to_network
    action :detach_from_network

    action :change_alias_ips
    action :change_dns_ptr

    action :change_protection
    action :change_type
    action :create_image

    action :enable_backup
    action :disable_backup

    action :enable_rescue
    action :disable_rescue

    action :poweron
    action :poweroff
    action :reboot
    action :reset
    action :shutdown

    action :reset_password

    action :rebuild

    action :request_console

    def creatable_attributes
      [:name, :automount, :start_after_create, :user_data, :labels, datacenter: [:id, :name], image: [:id, :name], location: [:id, :name], server_type: [:id, :name], ssh_keys: [:id, :name], firewalls: :id, networks: :id, volumes: :id]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
