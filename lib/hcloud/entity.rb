# frozen_string_literal: true

module HCloud
  # @!visibility private
  class Entity
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    include DeprecatedAttributes
    include DynamicAttributes

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def inspect
      "#<#{self.class} #{attributes.filter_map do |name, value|
        "#{name}: #{
        if value.is_a?(Resource) || value.is_a?(Entity)
          '<...>'
        else
          value.is_a?(Enumerable) ? '[...]' : value.inspect
        end}"
      end.join(', ')}>"
    end

    def to_h
      attributes
        .transform_values { |v| v.try(:to_h) || v }
        .compact_blank
    end
  end
end
