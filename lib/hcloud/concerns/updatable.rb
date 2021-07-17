# frozen_string_literal: true

module HCloud
  module Updatable
    extend ActiveSupport::Concern

    included do
      def update
        assign_attributes client
          .put("/#{resource_name.pluralize}/#{id}", attributes.slice(*updatable_attributes.map(&:to_s)))
          .fetch(resource_name.to_sym)
      end

      def updatable_attributes
        []
      end
    end
  end
end
