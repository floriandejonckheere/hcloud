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
  #     HCloud::Server.all.sort(name: :desc)
  #     # => [#<HCloud::Server id: 1, ...>, ...]
  #
  #     HCloud::Server.all.sort(:id, name: :asc)
  #     # => [#<HCloud::Server id: 1, ...>, ...]
  #
  # == Search servers
  #
  #     HCloud::Server.all.where(name: "cx11")
  #     # => #<HCloud::Server id: 1, ...>
  #
  #     HCloud::Server.all.where(status: "running")
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
  #     server = HCloud::Server.new(name: "my_server", image: "my_image", server_type: "cx11")
  #     server.create
  #     server.created?
  #     # => true
  #
  # == Update server
  #
  #     server = HCloud::Server.find(1)
  #     server.name = "another_serve"
  #     server.update
  #
  # == Delete server
  #
  #     server = HCloud::Server.find(1)
  #     server.delete
  #     server.deleted?
  #     # => true
  #
  # TODO: actions
  # TODO: metrics
  # TODO: return root_password if ssh_keys is empty
  #
  class Server < Resource
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name

    attribute :server_type, :server_type

    attribute :status

    attribute :backup_window

    # TODO: use only for creation
    attribute :location, :location

    # TODO: use only for creation
    attribute :ssh_keys, :ssh_key, array: true, default: []

    # TODO: use only for creation
    attribute :firewalls, array: true, default: []

    # TODO: use only for creation
    attribute :networks, array: true, default: []

    attribute :datacenter, :datacenter

    attribute :included_traffic, :integer
    attribute :ingoing_traffic, :integer
    attribute :outgoing_traffic, :integer

    attribute :primary_disk_size, :integer

    attribute :protection, :protection

    attribute :image, :image

    # TODO: network resource
    attribute :public_net
    attribute :private_net

    attribute :iso, :iso

    attribute :labels, default: -> { {} }

    # TODO: load balancer resource
    attribute :load_balancers, array: true, default: []

    attribute :volumes, :volume, array: true, default: []

    attribute :locked
    attribute :rescue_enabled

    alias rescue_enabled? rescue_enabled

    alias locked? locked

    def creatable_attributes
      [:name, :automount, :start_after_create, :user_data, :labels, datacenter: [:id, :name], image: [:id, :name], location: [:id, :name], server_type: [:id, :name], ssh_keys: [:id, :name], firewalls: :id, networks: :id, volumes: :id]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
