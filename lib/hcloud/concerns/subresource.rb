# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Subresource
    extend ActiveSupport::Concern

    delegate :resource_path, to: :class

    def instance_path
      resource_path(id: id)
    end

    included do
      # For super resources
      class_attribute :subresource_names

      self.subresource_names = []

      # For subresources
      class_attribute :resource_class
    end

    class_methods do # rubocop:disable Metrics/BlockLength
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
        raise ArgumentError, "Resource already a subresource of #{resource_class}" if resource_class.present?

        self.resource_class = ActiveModel::Type
          .lookup(type)
          .resource_class

        attribute name, :integer # TODO: override that returns the resource class instance instead of the ID?

        # Nested resources (e.g. /storage_boxes/123/subaccounts)
        define_method(:resource_path) do |id: nil|
          super_instance = public_send(resource_class.resource_name)

          return super() if super_instance.blank?

          if super_instance.respond_to?(:instance_path)
            [super_instance.instance_path, super(id: id)].join
          else
            [resource_class.resource_path(id: super_instance), super(id: id)].join
          end
        end
      end

      def resource_path(id: nil)
        ["", resource_name.pluralize, id].compact.join("/")
      end
    end
  end
end
