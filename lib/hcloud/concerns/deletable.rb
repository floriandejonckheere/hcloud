# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Deletable
    extend ActiveSupport::Concern

    included do
      def delete
        raise Errors::MissingIDError unless id

        response = client
          .delete("#{resource_path}/#{id}")

        @deleted = true

        # Return the resource instance
        return self unless response.is_a?(Hash) && response.key?(:action)

        # Some resources return an action instead of the resource itself (e.g. Storage Box API)
        # Return an Action instance
        Action.new response[:action]
      end

      def deleted?
        @deleted.present?
      end
    end
  end
end
