# frozen_string_literal: true

module HCloud
  module Actionable
    extend ActiveSupport::Concern

    included do
      def actions
        ActionCollection.new(self)
      end
    end
  end
end
