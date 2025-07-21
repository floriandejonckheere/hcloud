# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Subresource
    extend ActiveSupport::Concern

    included do
      # For super resources
      class_attribute :subresource_names

      self.subresource_names = []

      # For subresources
      class_attribute :resource_class
    end

    class_methods do
      def inherited(subclass)
        super

        subclass.subresource_names = subresource_names.dup
      end

      # For super resources
      def subresource(name, type = name)
        subresource_names << name.to_s.pluralize

        define_method(name.to_s.pluralize) do
          raise Errors::MissingIDError unless id

          SubCollection.new(name, type, self)
        end
      end

      # For subresources
      def subresource_of(name, type = name)
        self.resource_class = ActiveModel::Type
          .lookup(type)
          .resource_class

        attribute name, :integer

        # TODO: override that returns the resource class instance instead of the ID?
      end

      def resource_path
        "/#{resource_name.pluralize}"
      end
    end

    def resource_path
      if resource_class && (id = send(resource_class.resource_name)).present?
        # Nested resources (e.g. /storage_boxes/123/subaccounts)
        "/#{resource_class.resource_name.pluralize}/#{id}/#{resource_name.pluralize}"
      else
        # Top-level resources (e.g. /servers)
        "/#{resource_name.pluralize}"
      end
    end
  end
end
