# frozen_string_literal: true

module HCloud
  ##
  # Represents a DNS zone
  #
  # == List all zones
  #
  #     HCloud::Zone.all
  #     # => [#<HCloud::Zone id: 1, ...>, ...]
  #
  # == Sort zones
  #
  #     HCloud::Zone.sort(name: :desc)
  #     # => [#<HCloud::Zone id: 1, ...>, ...]
  #
  #     HCloud::Zone.sort(:id, name: :asc)
  #     # => [#<HCloud::Zone id: 1, ...>, ...]
  #
  # == Search zones
  #
  #     HCloud::Zone.where(name: "my_zone")
  #     # => #<HCloud::Zone id: 1, ...>
  #
  #     HCloud::Zone.where(mode: "primary")
  #     # => #<HCloud::Zone id: 1, ...>
  #
  #     HCloud::Zone.where(label_selector: "environment=production")
  #     # => #<HCloud::Zone id: 1, ...>
  #
  # == Find zone by ID
  #
  #     HCloud::Zone.find(1)
  #     # => #<HCloud::Zone id: 1, ...>
  #
  # == Create zone
  #
  #     zone = HCloud::Zone.new(name: "my_zone", mode: "primary", ttl: 10800)
  #     zone.create
  #     zone.created?
  #     # => true
  #
  #     zone = HCloud::Zone.create(name: "my_zone", mode: "primary", ttl: 10800)
  #     # => #<HCloud::Zone id: 1, ...>
  #
  # == Update zone
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.labels = { environment: "production" }
  #     zone.update
  #
  # == Delete zone
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.delete
  #     zone.deleted?
  #     # => true
  #
  # == Export zone file
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.export
  #     # => "$ORIGIN\texample.com.\n$TTL\t3600\n\n@\tIN\tSOA\thydrogen.ns.hetzner.com. dns.hetzner.com. ..."
  #
  class Zone < Resource
    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id, :integer
    attribute :name

    attribute :mode

    attribute :primary_nameservers, :nameserver, array: true, default: -> { [] }
    attribute :authoritative_nameservers, :authoritative_nameservers

    attribute :record_count, :integer
    attribute :ttl, :integer
    attribute :status
    attribute :registrar

    attribute :protection, :protection

    def export
      client
        .get("#{resource_path}/#{id}/zonefile")
        .fetch(:zonefile)
    end

    def creatable_attributes
      [:name, :mode, :ttl, :labels, :primary_nameservers, :rrsets]
    end

    def updatable_attributes
      [:labels]
    end
  end
end
