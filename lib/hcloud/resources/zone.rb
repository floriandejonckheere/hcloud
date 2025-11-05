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
  #     zone = HCloud::Zone.new(name: "my_zone", mode: "primary", ttl: 10800, rrsets: [{ name: "www", type: "A", records: [{ value: "198.51.100.1", comment: "My web server at Hetzner Cloud" }] }])
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
  # = Actions
  # == List actions
  #
  #     actions = HCloud::Zone.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::Zone.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Zone.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Zone.find(1).actions.where(command: "import_zonefile")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Zone.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::Zone.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Resource-specific actions
  # == Change a zone's primary nameservers
  #
  #     HCloud::Zone.find(1).change_primary_nameservers(primary_nameservers: [{ address: "198.51.100.1", port: 53 }, { address: "203.0.113.1", port: 53 }])
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change protection
  #
  #     HCloud::Zone.find(1).change_protection(delete: true)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change default TTL
  #
  #     HCloud::Zone.find(1).change_ttl(ttl: 10800)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Import zone file
  #
  #     HCloud::Zone.find(1).import_zonefile(zonefile: "$ORIGIN\texample.com.\n$TTL\t3600\n\n@\tIN\tSOA\thydrogen.ns.hetzner.com. dns.hetzner.com. ...")
  #     # => #<HCloud::Action id: 1, ...>
  #
  class Zone < Resource
    actionable
    queryable
    creatable
    updatable
    deletable
    labelable

    subresource :rrset, :rrset

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

    action :change_primary_nameservers
    action :change_protection
    action :change_ttl
    action :import_zonefile

    def export
      raise Errors::MissingIDError unless id

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
