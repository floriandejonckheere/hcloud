# frozen_string_literal: true

module HCloud
  class ServerProtection < Entity
    attribute :delete, :boolean
    attribute :rebuild, :boolean

    alias delete? delete
    alias rebuild? rebuild
  end
end
