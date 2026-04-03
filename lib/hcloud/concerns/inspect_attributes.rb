# frozen_string_literal: true

module HCloud
  # @!visibility private
  module InspectAttributes
    extend ActiveSupport::Concern

    included do
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
    end
  end
end
