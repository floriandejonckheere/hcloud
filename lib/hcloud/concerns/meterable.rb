# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Meterable
    extend ActiveSupport::Concern

    included do
      def metrics(type:, from:, to:, step: nil)
        raise Errors::MissingIDError unless id

        Metrics.new client
          .get("#{resource_path}/#{id}/metrics", type: Array(type).join(","), start: from.iso8601, end: to.iso8601, step: step)
          .fetch(:metrics)
      end
    end
  end
end
