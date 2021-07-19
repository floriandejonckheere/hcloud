# frozen_string_literal: true

module HCloud
  module Associatable
    extend ActiveSupport::Concern

    included do
      class_attribute :association_names

      self.association_names = []
    end

    class_methods do
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def association(name, type)
        association_names << name.to_s

        define_method(name) do
          Collection.new do |params|
            response = client
              .get("/#{resource_name.pluralize}/#{id}/#{name.to_s.pluralize}", params)

            data = response
              .fetch(name.to_s.pluralize.to_sym)
              .map { |attrs| "HCloud::#{type.to_s.camelize}".constantize.new attrs }

            meta = response
              .fetch(:meta)

            [data, meta]
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
