# frozen_string_literal: true

module HCloud
  # @!visibility private
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
          raise Errors::MissingIDError unless id

          response = client
            .post("#{resource_path}/#{id}/actions/#{name}", params)

          if response.key?(:actions)
            response[:actions].map { |r| Action.new r }
          else
            Action.new response[:action]
          end
        end
      end
    end
  end
end
