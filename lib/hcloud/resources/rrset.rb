# frozen_string_literal: true

module HCloud
  ##
  # Represents a DNS zone's RRSet
  #
  # == List all RRSets
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets
  #     # => [#<HCloud::RRSet id: 1, ...>, ...]
  #
  # == Sort RRSets
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.sort(name: :desc)
  #     # => [#<HCloud::RRSet id: 1, ...>, ...]
  #
  #     zone.rrsets.sort(:id, name: :asc)
  #     # => [#<HCloud::RRSet id: 1, ...>, ...]
  #
  # == Search RRSets
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.where(name: "my_zone")
  #     # => #<HCloud::RRSet id: 1, ...>
  #
  #     zone.rrsets.where(type: "AAAA")
  #     # => #<HCloud::RRSet id: 1, ...>
  #
  #     zone.rrsets.where(label_selector: "environment=production")
  #     # => #<HCloud::RRSet id: 1, ...>
  #
  # == Find RRSet by ID
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1)
  #     # => #<HCloud::RRSet id: 1, ...>
  #
  # == Create RRSet
  #
  #     zone = HCloud::Zone.find(1)
  #     rrset = zone.rrsets.new(name: "my_rrset", type: "A", ttl: 10800, records: [{ value: "198.51.100.1", comment: "My web server at Hetzner Cloud" }])
  #     rrset.create
  #     rrset.created?
  #     # => true
  #
  # == Update RRSet
  #
  #     zone = HCloud::Zone.find(1)
  #     rrset = zone.rrsets.find(1)
  #     rrset.name = "another_rrset"
  #     rrset.update
  #
  # == Delete RRSet
  #
  #     zone = HCloud::Zone.find(1)
  #     rrset = zone.rrsets.find(1)
  #     rrset.delete
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     rrset.deleted?
  #     # => true
  #
  # = Actions
  # == List actions
  #
  #     zone = HCloud::Zone.find(1)
  #     actions = zone.rrsets.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).actions.where(command: "change_protection")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Resource-specific actions
  # == Change protection
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).change_protection(change: true)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change TTL
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).change_ttl(ttl: 10800)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Set records
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).set_records(records: [{ value: "198.51.100.1", comment: "My web server at Hetzner Cloud" }])
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Add records
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).add_records(ttl: 10800, records: [{ value: "198.51.100.1", comment: "My web server at Hetzner Cloud" }])
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Remove records
  #
  #     zone = HCloud::Zone.find(1)
  #     zone.rrsets.find(1).remove_records(records: [{ value: "198.51.100.1", comment: "My web server at Hetzner Cloud" }])
  #     # => #<HCloud::Action id: 1, ...>
  #
  class RRSet < Resource
    subresource_of :zone

    actionable
    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id
    attribute :name

    attribute :type

    attribute :ttl, :integer

    attribute :protection, :change_protection

    attribute :records, :record, array: true, default: -> { [] }

    attribute :zone, :zone

    action :change_protection
    action :change_ttl
    action :set_records
    action :add_records
    action :remove_records

    def creatable_attributes
      [:name, :type, :ttl, :records, :labels]
    end

    def updatable_attributes
      [:labels]
    end
  end
end
