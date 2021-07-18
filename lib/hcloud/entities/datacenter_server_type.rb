# frozen_string_literal: true

module HCloud
  class DatacenterServerType < Entity
    attribute :available, array: true
    attribute :available_for_migration, array: true
    attribute :supported, array: true
  end
end
