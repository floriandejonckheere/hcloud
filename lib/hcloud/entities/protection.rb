# frozen_string_literal: true

module HCloud
  class Protection < Entity
    attribute :delete, :boolean

    alias delete? delete
  end
end
