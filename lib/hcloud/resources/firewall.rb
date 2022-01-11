# frozen_string_literal: true

module HCloud
  ##
  # Represents a firewall
  #
  # == List all firewalls
  #
  #     HCloud::Firewall.all
  #     # => [#<HCloud::Firewall id: 1, ...>, ...]
  #
  # == Sort firewalls
  #
  #     HCloud::Firewall.all.sort(name: :desc)
  #     # => [#<HCloud::Firewall id: 1, ...>, ...]
  #
  #     HCloud::Firewall.all.sort(:id, name: :asc)
  #     # => [#<HCloud::Firewall id: 1, ...>, ...]
  #
  # == Search firewalls
  #
  #     HCloud::Firewall.all.where(name: "my_irewall")
  #     # => #<HCloud::Firewall id: 1, ...>
  #
  # == Find firewall by ID
  #
  #     HCloud::Firewall.find(1)
  #     # => #<HCloud::Firewall id: 1, ...>
  #
  # == Create firewall
  #
  #     firewall = HCloud::Firewall.new(name: "my_firewall")
  #     firewall.create
  #     firewall.created?
  #     # => true
  #
  #     firewall = HCloud::Firewall.create(name: "my_firewall")
  #     # => #<HCloud::Firewall id: 1, ...>
  #
  # == Update firewall
  #
  #     firewall = HCloud::Firewall.find(1)
  #     firewall.name = "another_firewall"
  #     firewall.update
  #
  # == Delete firewall
  #
  #     firewall = HCloud::Firewall.find(1)
  #     firewall.delete
  #     firewall.deleted?
  #     # => true
  #
  # TODO: firewall actions
  #
  class Firewall < Resource
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name

    attribute :applied_to, :applied_to, array: true, default: -> { [] }
    # Only used for creation
    attribute :apply_to, :apply_to, array: true, default: -> { [] }

    attribute :rules, :rule, array: true, default: -> { [] }

    attribute :labels, default: -> { {} }

    def creatable_attributes
      [:name, :labels, :apply_to, :rules]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
