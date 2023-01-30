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
  #     HCloud::Firewall.all.where(name: "my_firewall")
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
  # = Actions
  # == List actions
  #
  #     actions = HCloud::Firewall.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::Firewall.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Firewall.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Firewall.find(1).actions.where(command: "set_rules")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Firewall.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::Firewall.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Resource-specific actions
  # == Apply a firewall to resources
  #
  #     firewall = HCloud::Firewall.find(1)
  #     server = HCloud::Server.find(1)
  #
  #     firewall.apply_to_resources(apply_to: [{ type: "server", server: { id: server.id } }])
  #     # => #<HCloud::Action ...>
  #
  # == Remove a firewall from resources
  #
  #     firewall = HCloud::Firewall.find(1)
  #     server = HCloud::Server.find(1)
  #
  #     firewall.remove_from_resources(remove_from: [{ type: "server", server: { id: server.id } }])
  #     # => #<HCloud::Action ...>
  #
  # == Set firewall rules
  #
  #     firewall = HCloud::Firewall.find(1)
  #
  #     firewall.set_rules(rules: [{ direction: "in", protocol: "tcp", ... }])
  #     # => #<HCloud::Action ...>
  #
  class Firewall < Resource
    actionable
    queryable
    creatable
    updatable
    deletable
    labelable

    attribute :id, :integer
    attribute :name

    attribute :applied_to, :applied_to, array: true, default: -> { [] }
    # TODO: use only for creation
    attribute :apply_to, :apply_to, array: true, default: -> { [] }

    attribute :rules, :rule, array: true, default: -> { [] }

    action :apply_to_resources
    action :remove_from_resources
    action :set_rules

    def creatable_attributes
      [:name, :labels, :apply_to, :rules]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
