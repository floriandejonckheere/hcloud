# frozen_string_literal: true

module HCloud
  module Updatable
    extend ActiveSupport::Concern

    included do
      def update(**attributes)
        raise Errors::MissingIDError unless id

        assign_attributes attributes

        assign_attributes client
          .put("/#{resource_name.pluralize}/#{id}", updatable_params)
          .fetch(resource_name.to_sym)

        self
      end

      def updatable_attributes
        []
      end

      # Convert updatable_attributes into a key-value list
      def updatable_params
        attributes.slice(*updatable_attributes.map(&:to_s))
      end
    end
  end
end
