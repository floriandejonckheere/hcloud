# frozen_string_literal: true

module HCloud
  ##
  # Represents a placement group
  #
  # == List all placement group
  #
  #     HCloud::PlacementGroup.all
  #     # => [#<HCloud::PlacementGroup id: 2, ...>, ...]
  #
  # == Sort placement groups
  #
  #     HCloud::PlacementGroup.sort(name: :desc)
  #     # => [#<HCloud::PlacementGroup id: 1, ...>, ...]
  #
  #     HCloud::PlacementGroup.sort(:id, name: :asc)
  #     # => [#<HCloud::PlacementGroup id: 1, ...>, ...]
  #
  # == Search placement groups
  #
  #     HCloud::PlacementGroup.where(name: "my_placement_group")
  #     # => #<HCloud::PlacementGroup id: 2, ...>
  #
  #     HCloud::PlacementGroup.where(label_selector: { environment: "production" })
  #     # => #<HCloud::PlacementGroup id: 2, ...>
  #
  # == Find placement group by ID
  #
  #     HCloud::PlacementGroup.find(2)
  #     # => #<HCloud::PlacementGroup id: 2, ...>
  #
  # == Create placement group
  #
  #     placement_group = HCloud::PlacementGroup.new(name: "my_placement_group", type: "spread")
  #     placement_group.create
  #     placement_group.created?
  #     # => true
  #
  #     firewall = HCloud::PlacementGroup.create(name: "my_placement_group")
  #     # => #<HCloud::PlacementGroup id: 1, ...>
  #
  # == Update placement group
  #
  #     placement_group = HCloud::PlacementGroup.find(1)
  #     placement_group.name = "another_placement_group"
  #     placement_group.update
  #
  # == Delete placement group
  #
  #     placement_group = HCloud::PlacementGroup.find(1)
  #     placement_group.delete
  #     placement_group.deleted?
  #     # => true
  #
  class PlacementGroup < Resource
    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id, :integer
    attribute :name
    attribute :type

    attribute :servers, :server, array: true, default: -> { [] }

    def creatable_attributes
      [:name, :type, :labels]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
