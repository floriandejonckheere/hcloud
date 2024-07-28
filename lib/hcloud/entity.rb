# frozen_string_literal: true

module HCloud
  # @!visibility private
  class Entity
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def inspect
      "#<#{self.class} #{attributes.filter_map { |name, value| "#{name}: #{value.inspect}" }.join(', ')}>"
    end

    def to_h
      attributes
        .transform_values { |v| v.try(:to_h) || v }
        .compact_blank
    end
  end
end
