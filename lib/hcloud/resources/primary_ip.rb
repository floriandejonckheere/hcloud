# frozen_string_literal: true

module HCloud
  ##
  # Represents a primary IP
  #
  # == List all primary IPs
  #
  #     HCloud::PrimaryIP.all
  #     # => [#<HCloud::PrimaryIP id: 1, ...>, ...]
  #
  # == Sort primary IPs
  #
  #     HCloud::PrimaryIP.all.sort(id: :asc)
  #     # => [#<HCloud::PrimaryIP id: 1, ...>, ...]
  #
  #     HCloud::PrimaryIP.all.sort(:id, created: :asc)
  #     # => [#<HCloud::PrimaryIP id: 1, ...>, ...]
  #
  # == Search primary IPs
  #
  #     HCloud::PrimaryIP.all.where(name: "my_primary_ip")
  #     # => #<HCloud::PrimaryIP id: 1, ...>
  #
  #     HCloud::PrimaryIP.all.where(ip: "1.2.3.4")
  #     # => #<HCloud::PrimaryIP id: 1, ...>
  #
  # == Find primary IP by ID
  #
  #     HCloud::PrimaryIP.find(1)
  #     # => #<HCloud::PrimaryIP id: 1, ...>
  #
  # == Create primary IP
  #
  #     primary IP = HCloud::PrimaryIP.new(name: "my_primary_ip", type: "ipv4", datacenter: "fsn1-dc8")
  #     primary IP.create
  #     primary IP.created?
  #     # => true
  #
  #     firewall = HCloud::PrimaryIP.create(name: "my_primary_ip")
  #     # => #<HCloud::PrimaryIP id: 1, ...>
  #
  # == Update primary IP
  #
  #     primary IP = HCloud::PrimaryIP.find(1)
  #     primary IP.name = "another_primary_ip"
  #     primary IP.update
  #
  # == Delete primary IP
  #
  #     primary IP = HCloud::PrimaryIP.find(1)
  #     primary IP.delete
  #     primary IP.deleted?
  #     # => true
  #
  class PrimaryIP < Resource
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name

    attribute :type
    attribute :ip
    attribute :dns_ptr, :dns_pointer, array: true, default: -> { [] }

    attribute :assignee_id
    attribute :assignee_type, default: "server"

    attribute :auto_delete, :boolean
    attribute :blocked, :boolean

    attribute :datacenter, :datacenter

    attribute :protection, :protection

    attribute :labels, default: -> { {} }

    alias auto_delete? auto_delete
    alias blocked? blocked

    def creatable_attributes
      [:name, :type, :assignee_id, :assignee_type, :auto_delete, :labels, datacenter: [:id, :name]]
    end

    def updatable_attributes
      [:name, :auto_delete, :labels]
    end
  end
end
