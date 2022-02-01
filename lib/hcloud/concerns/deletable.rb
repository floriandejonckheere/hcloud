# frozen_string_literal: true

module HCloud
  module Deletable
    extend ActiveSupport::Concern

    included do
      def delete
        raise Errors::MissingIDError unless id

        client
          .delete("/#{resource_name.pluralize}/#{id}")

        @deleted = true
      end

      def deleted?
        @deleted.present?
      end
    end
  end
end
