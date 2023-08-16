# frozen_string_literal: true

module HCloud
  ##
  # Represents a location
  #
  # == List all locations
  #
  #     HCloud::Location.all
  #     # => [#<HCloud::Location id: 1, ...>, ...]
  #
  # == Sort locations
  #
  #     HCloud::Location.sort(name: :desc)
  #     # => [#<HCloud::Location id: 1, ...>, ...]
  #
  #     HCloud::Location.sort(:id, name: :asc)
  #     # => [#<HCloud::Location id: 1, ...>, ...]
  #
  # == Search locations
  #
  #     HCloud::Location.where(name: "fsn1")
  #     # => #<HCloud::Location id: 1, ...>
  #
  # == Find location by ID
  #
  #     HCloud::Location.find(1)
  #     # => #<HCloud::Location id: 1, ...>
  #
  class Location < Resource
    queryable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :network_zone

    attribute :city
    attribute :country

    attribute :latitude, :decimal
    attribute :longitude, :decimal
  end
end
