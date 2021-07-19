# frozen_string_literal: true

module HCloud
  class Protection < Entity
    attribute :delete, :boolean
    attribute :rebuild, :boolean

    alias delete? delete
    alias rebuild? rebuild
  end
end
