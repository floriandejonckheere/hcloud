# frozen_string_literal: true

module HCloud
  module Actionable
    extend ActiveSupport::Concern

    included do
      class_attribute :action_names

      self.action_names = []

      def actions
        ActionCollection.new(self)
      end
    end

    class_methods do
      def action(name)
        action_names << name.to_s

        define_method(name) do |**params|
          Action.new client
            .post("/#{resource_name.pluralize}/#{id}/actions/#{name}", params)
            .fetch(:action)
        end
      end
    end
  end
end
