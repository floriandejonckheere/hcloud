# frozen_string_literal: true

module HCloud
  ##
  # Represents an action
  #
  # == List all actions
  #
  #     HCloud::Action.all
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::Action.sort(command: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Action.sort(:id, command: :asc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Action.where(command: "my_action")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Action.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::Action.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  class Action < Resource
    queryable

    attribute :id, :integer
    attribute :command

    attribute :started, :datetime
    attribute :finished, :datetime
    attribute :progress, :integer

    attribute :status
    attribute :error, :error

    attribute :resources, :resource, array: true, default: -> { [] }

    class << self
      def all
        warn "[DEPRECATION] Starting on 1 October 2023, this endpoint will no longer be available. After that, it won't be possible anymore to list all actions across all resources. As an alternative, you can use the action endpoints of a specific resource to list all actions (e.g. of all servers or of all Load Balancers)."

        super
      end
    end
  end
end
