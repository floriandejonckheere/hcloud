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
  #     HCloud::FloatingIP.all.where(name: "cx11")
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
  # TODO: actions
  #
  class FloatingIP < Resource
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :type
    attribute :ip
    attribute :dns_ptr, :dns_pointer, array: true

    attribute :blocked, :boolean

    attribute :home_location, :location

    attribute :protection, :protection

    # TODO: return Server object
    attribute :server, :integer

    attribute :labels, default: -> { {} }

    alias blocked? blocked

    def creatable_attributes
      [:name, :description, :type, :labels, { home_location: :name, server: :name }]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
