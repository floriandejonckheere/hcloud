# frozen_string_literal: true

module HCloud
  class Resource
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    include Concerns
    include DeprecatedAttributes
    include DynamicAttributes
    include InspectAttributes
    include Subresource

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def mutable?
      true
    end

    delegate :[], to: :attributes

    def to_h
      {
        id: id,
      }
    end

    def ==(other)
      id && id == other.id
    end

    def self.resource_name
      name.demodulize.underscore
    end

    def self.client
      HCloud::Client.connection
    end

    delegate :client, :resource_name, to: :class
  end
end
