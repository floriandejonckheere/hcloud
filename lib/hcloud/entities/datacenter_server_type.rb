# frozen_string_literal: true

module HCloud
  class DatacenterServerType < Entity
    attribute :available,
              array: true,
              default: -> { [] },
              deprecated: true

    attribute :available_for_migration,
              array: true,
              default: -> { [] },
              deprecated: true

    attribute :supported,
              array: true,
              default: -> { [] },
              deprecated: true
  end
end
