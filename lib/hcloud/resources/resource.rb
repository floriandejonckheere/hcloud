# frozen_string_literal: true

module HCloud
  class Resource
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def create
      assign_attributes client
        .post("/#{resource_name.pluralize}", attributes.slice(*creatable_attributes.map(&:to_s)))
        .fetch(resource_name.to_sym)
    end

    def update
      assign_attributes client
        .put("/#{resource_name.pluralize}/#{id}", attributes.slice(*updatable_attributes.map(&:to_s)))
        .fetch(resource_name.to_sym)
    end

    def delete
      client
        .delete("/#{resource_name.pluralize}/#{id}")

      @deleted = true
    end

    def created?
      created.present?
    end

    def deleted?
      @deleted.present?
    end

    def creatable_attributes
      []
    end

    def updatable_attributes
      []
    end

    def inspect
      "#<#{self.class} #{attributes.filter_map { |name, value| "#{name}: #{value.inspect}" }.join(', ')}>"
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
