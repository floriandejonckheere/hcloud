# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Singleton
    extend ActiveSupport::Concern

    included do
      def reload
        assign_attributes client
          .get("/#{resource_name}")
          .fetch(resource_name.to_sym)

        self
      end
    end

    class_methods do
      def find
        new client
          .get("/#{resource_name}")
          .fetch(resource_name.to_sym)
      end
    end
  end
end
