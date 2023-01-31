# frozen_string_literal: true

module HCloud
  ##
  # Represents a datacenter
  #
  # == List all datacenters
  #
  #     HCloud::Datacenter.all
  #     # => [#<HCloud::Datacenter id: 2, ...>, ...]
  #
  # == Search datacenters
  #
  #     HCloud::Datacenter.where(name: "fsn1-dc8")
  #     # => #<HCloud::Datacenter id: 2, ...>
  #
  # == Find datacenter by ID
  #
  #     HCloud::Datacenter.find(2)
  #     # => #<HCloud::Datacenter id: 2, ...>
  #
  # == Get datacenter recommendation
  #
  #     HCloud::Datacenter.recommendation
  #     # => #<HCloud::Datacenter id: 2, ...>
  #
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
