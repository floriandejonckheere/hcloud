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
  #     rrset = zone.rrsets.new(name: "my_rrset", type: "AAAA", ttl: 10800, records: [{ value: "198.51.100.1", comment: "My web server at Hetzner Cloud" }])
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
  class RRSet < Resource
    subresource_of :zone

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

    def creatable_attributes
      [:name, :type, :ttl, :records, :labels]
    end

    def updatable_attributes
      [:labels]
    end
  end
end
