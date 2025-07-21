# frozen_string_literal: true

module HCloud
  # @!visibility private
  class ActionCollection < Collection
    attr_reader :resource

    def initialize(resource)
      super(&method(:all))

      @resource = resource
    end

    def find(id)
      Action.new resource
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
        .fetch(:actions)
        .map { |attrs| Action.new attrs }

      meta = response
        .fetch(:meta)

      [data, meta]
    end
  end
end
