# frozen_string_literal: true

module HCloud
  module Creatable
    extend ActiveSupport::Concern

    included do
      attribute :created, :datetime

      def create
        assign_attributes client
          .post("/#{resource_name.pluralize}", creatable_params)
          .fetch(resource_name.to_sym)
      end

      def created?
        created.present?
      end

      def creatable_attributes
        []
      end

      # Convert creatable_attributes into a key-value list
      # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
      def creatable_params
        nested_attributes, resource_attributes = creatable_attributes.partition { |a| a.respond_to? :each }

        attributes
          .slice(*resource_attributes.map(&:to_s))
          .merge(nested_attributes.reduce(&:merge)&.map { |k, v| [k.to_s, Array(v).filter_map { |w| send(k)&.send_wrap(w) }.first] }.to_h)
          .compact
      end
      # rubocop:enable Metrics/AbcSize,Metrics/CyclomaticComplexity
    end
  end
end
