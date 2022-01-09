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
  #     HCloud::Action.all.sort(command: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Action.all.sort(:id, command: :asc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Action.all.where(command: "my_action")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Action.all.where(status: "success")
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

    # TODO: return array of resources
    attribute :resources, array: true, default: -> { [] }
  end
end
