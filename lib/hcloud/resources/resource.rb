# frozen_string_literal: true

module HCloud
  class Resource
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def inspect
      "#<#{self.class} #{attributes.filter_map { |name, value| "#{name}: #{value || 'nil'}" }.join(', ')}>"
    end

    def self.find(id)
      new client
        .get("/#{resource_name.pluralize}/#{id}")
        .fetch(resource_name.to_sym)
    end

    def self.all
      # TODO: pagination
      client
        .get("/#{resource_name.pluralize}")
        .fetch(resource_name.pluralize.to_sym)
        .map { |attrs| new attrs }
    end

    def self.resource_name
      name.demodulize.underscore
    end

    def self.client
      HCloud::Client.connection
    end
  end
end
