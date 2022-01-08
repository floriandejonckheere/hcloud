# frozen_string_literal: true

module HCloud
  class Resource
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    include Concerns

    def initialize(attributes = {})
      super()

      assign_attributes(attributes) if attributes
    end

    delegate :[], to: :attributes

    def inspect
      "#<#{self.class} #{attributes.filter_map { |name, value| "#{name}: #{value.inspect}" }.join(', ')}>"
    end

    def self.resource_name
      name.demodulize.underscore
    end

    def self.client
      HCloud::Client.connection
    end

    delegate :client, :resource_name, to: :class
  end
end
