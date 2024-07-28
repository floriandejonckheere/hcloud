# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Queryable
    extend ActiveSupport::Concern

    included do
      def reload
        raise Errors::MissingIDError unless id

        assign_attributes client
          .get("/#{resource_name.pluralize}/#{id}")
          .fetch(resource_name.to_sym)

        self
      end
    end

    class_methods do
      delegate :first, :last, :count, :where, :sort, :each, :empty?, :any?, to: :all

      def find(id)
        raise Errors::MissingIDError unless id

        new client
          .get("/#{resource_name.pluralize}/#{id}")
          .fetch(resource_name.to_sym)
      end

      def all
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
    end
  end
end
