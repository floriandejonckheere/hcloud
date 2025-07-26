# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Creatable
    extend ActiveSupport::Concern

    included do # rubocop:disable Metrics/BlockLength
      attribute :created, :datetime

      def create
        response = client
          .post(resource_path, creatable_params)

        # Some resources return an action instead of the resource itself (e.g. Storage Box API)
        if response.key?(:action)
          # Set the ID from the action response
          self.id = response
            .dig(:action, :resources)
            .find { |r| r[:type] == [resource_class&.resource_name, resource_name].compact.join("_") }
            .fetch(:id)

          # Return an Action instance
          Action.new response[:action]
        else
          # Set the attributes from the response
          assign_attributes response[resource_name.to_sym]
            .merge!(response.slice(:root_password))

          # Return the resource instance
          self
        end
      end

      def created?
        created.present?
      end

      def creatable_attributes
        []
      end

      # Convert creatable_attributes into a key-value list
      # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      def creatable_params
        # Split simple and nested attributes
        nested_attributes, simple_attributes = creatable_attributes.partition { |a| a.respond_to? :each }

        attributes
          .slice(*simple_attributes.map(&:to_s))
          .transform_values { |v| v&.send_wrap { |o| o.try(:to_h) || o } || v&.send_wrap(:to_s) }
          .merge(nested_attributes.reduce(&:merge).to_h { |k, v| [k.to_s, Array(v).filter_map { |w| send(k)&.send_wrap(w) }.first] })
          .compact_blank
      end
      # rubocop:enable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    end

    class_methods do
      def create(**attributes)
        new(attributes)
          .tap(&:create)
      end
    end
  end
end
