# frozen_string_literal: true

module HCloud
  class DatacenterServerType < Entity
    attribute :available, array: true, default: []
    attribute :available_for_migration, array: true, default: []
    attribute :supported, array: true, default: []
  end
end
