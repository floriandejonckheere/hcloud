# frozen_string_literal: true

module HCloud
  class ServerTypeLocation < Entity
    attribute :id, :integer
    attribute :name
    attribute :deprecation, :deprecation

    attribute :available, :boolean
    attribute :recommended, :boolean
  end
end
