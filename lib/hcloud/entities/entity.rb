# frozen_string_literal: true

module HCloud
  class Entity
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    def inspect
      "#<#{self.class} #{attributes.filter_map { |name, value| "#{name}: #{value&.inspect || 'nil'}" }.join(', ')}>"
    end
  end
end
