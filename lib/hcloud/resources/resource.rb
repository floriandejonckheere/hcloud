# frozen_string_literal: true

module HCloud
  class Resource
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def save; end

    def delete; end

    def inspect
      "#<#{self.class} #{attributes.filter_map { |name, value| "#{name}: #{value || 'nil'}" }.join(', ')}>"
    end

    def self.find(id)
      new client
        .get("/#{resource_name.pluralize}/#{id}")
        .fetch(resource_name.to_sym)
    end

    def self.all
      Collection.new do |params|
        response = client
          .get("/#{resource_name.pluralize}", params)

        data = response
          .fetch(resource_name.pluralize.to_sym)
          .map { |attrs| new attrs }

        meta = response
          .fetch(:meta)

        [data, meta]
      end
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
