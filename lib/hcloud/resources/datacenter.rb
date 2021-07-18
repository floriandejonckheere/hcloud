# frozen_string_literal: true

module HCloud
  class Datacenter < Resource
    queryable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :location, :location
    attribute :server_types, :datacenter_server_type

    def self.recommendation
      find client
        .get("/#{resource_name.pluralize}")
        .fetch(:recommendation)
    end
  end
end
