# frozen_string_literal: true

module HCloud
  # @!visibility private
  class ActionCollection < Collection
    attr_reader :name, :resource

    def initialize(name, resource)
      super(&method(:all))

      @name = name
      @resource = resource
    end

    def find(id)
      resource_class.new resource
        .client
        .get("#{resource.resource_path}/#{resource.id}/#{name.to_s.pluralize}/#{id}")
        .fetch(:action)
    end

    private

    def all(params)
      response = resource
        .client
        .get("#{resource.resource_path}/#{resource.id}/#{name.to_s.pluralize}", params)

      data = response
        .fetch(name.to_s.pluralize.to_sym)
        .map { |attrs| resource_class.new attrs }

      meta = response
        .fetch(:meta) do
        {
          pagination: {
            page: 1,
            per_page: 50,
            previous_page: nil,
            next_page: nil,
            last_page: 1,
            total_entries: data.size,
          },
        }
      end

      [data, meta]
    end

    def resource_class
      @resource_class ||= ActiveModel::Type
        .lookup(name)
        .resource_class
    end
  end
end
