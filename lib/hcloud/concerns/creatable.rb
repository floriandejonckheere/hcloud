# frozen_string_literal: true

module HCloud
  module Creatable
    extend ActiveSupport::Concern

    included do
      def create
        assign_attributes client
          .post("/#{resource_name.pluralize}", attributes.slice(*creatable_attributes.map(&:to_s)))
          .fetch(resource_name.to_sym)
      end

      def created?
        created.present?
      end

      def creatable_attributes
        []
      end
    end
  end
end
