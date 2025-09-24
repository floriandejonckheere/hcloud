# frozen_string_literal: true

module HCloud
  class ServerTypeLocation < Entity
    attribute :id, :integer
    attribute :name
    attribute :deprecation, :deprecation
  end
end
