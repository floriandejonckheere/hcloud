# frozen_string_literal: true

module HCloud
  ##
  # Represents an action
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
      undef_method :all, :first, :last, :count, :where, :sort, :each, :empty?, :any?
    end
  end
end
