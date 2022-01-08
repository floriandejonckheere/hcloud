# frozen_string_literal: true

module HCloud
  ##
  # Represents a floating IP
  #
  # == List all floating IPs
  #
  #     HCloud::FloatingIP.all
  #     # => [#<HCloud::FloatingIP id: 1, ...>, ...]
  #
  # == Sort floating IPs
  #
  #     HCloud::FloatingIP.all.sort(id: :asc)
  #     # => [#<HCloud::FloatingIP id: 1, ...>, ...]
  #
  #     HCloud::FloatingIP.all.sort(:id, created: :asc)
  #     # => [#<HCloud::FloatingIP id: 1, ...>, ...]
  #
  # == Search floating IPs
  #
  #     HCloud::FloatingIP.all.where(name: "my_floating_ip")
  #     # => #<HCloud::FloatingIP id: 1, ...>
  #
  # == Find floating IP by ID
  #
  #     HCloud::FloatingIP.find(1)
  #     # => #<HCloud::FloatingIP id: 1, ...>
  #
  # == Create floating IP
  #
  #     floating IP = HCloud::FloatingIP.new(name: "my_floating_ip", type: "ipv4", home_location: "fsn1")
  #     floating IP.create
  #     floating IP.created?
  #     # => true
  #
  #     firewall = HCloud::FloatingIP.create(name: "my_floating_ip")
  #     # => #<HCloud::FloatingIP id: 1, ...>
  #
  # == Update floating IP
  #
  #     floating IP = HCloud::FloatingIP.find(1)
  #     floating IP.name = "another_floating_ip"
  #     floating IP.update
  #
  # == Delete floating IP
  #
  #     floating IP = HCloud::FloatingIP.find(1)
  #     floating IP.delete
  #     floating IP.deleted?
  #     # => true
  #
  # = Actions
  # == List actions
  #
  #     actions = HCloud::FloatingIP.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::FloatingIP.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::FloatingIP.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::FloatingIP.find(1).actions.where(command: "assign_floating_ip")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::FloatingIP.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::FloatingIP.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Floating IP-specific actions
  # == Assign a floating IP to a server
  #
  #     HCloud::FloatingIP.find(1).assign(server: 1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Unassign a floating IP from a server
  #
  #     HCloud::FloatingIP.find(1).unassign
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change reverse DNS entry
  #
  #     HCloud::FloatingIP.find(1).change_dns_ptr(dns_ptr: "server.example.com", ip: "1.2.3.4")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change protection
  #
  #     HCloud::FloatingIP.find(1).change_protection(delete: true)
  #     # => #<HCloud::Action id: 1, ...>
  #
  class FloatingIP < Resource
    actionable
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :type
    attribute :ip
    attribute :dns_ptr, :dns_pointer, array: true, default: []

    attribute :blocked, :boolean

    attribute :home_location, :location

    attribute :protection, :protection

    # TODO: return Server object
    attribute :server, :integer

    attribute :labels, default: -> { {} }

    alias blocked? blocked

    action :assign
    action :unassign

    action :change_dns_ptr

    action :change_protection

    def creatable_attributes
      [:name, :description, :type, :labels, home_location: [:id, :name], server: [:id, :name]]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
