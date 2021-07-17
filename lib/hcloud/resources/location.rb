# frozen_string_literal: true

module HCloud
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
