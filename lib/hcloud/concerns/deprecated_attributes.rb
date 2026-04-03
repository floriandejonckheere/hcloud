# frozen_string_literal: true

module HCloud
  # @!visibility private
  module DeprecatedAttributes
    extend ActiveSupport::Concern

    class_methods do
      def attribute(name, *, deprecated: false, **)
        super(name, *, **)

        define_method(name) do |**params|
          warn "[DEPRECATION] Field \"#{name}\" on #{self.class.name} is deprecated." if deprecated

          super(**params)
        end
      end
    end
  end
end
