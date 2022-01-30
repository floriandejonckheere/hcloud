# frozen_string_literal: true

module HCloud
  module Concerns
    extend ActiveSupport::Concern

    class_methods do
      def actionable
        include Actionable
      end

      def queryable
        include Queryable
      end

      def creatable
        include Creatable
      end

      def updatable
        include Updatable
      end

      def deletable
        include Deletable
      end

      def singleton
        include Singleton
      end
    end
  end
end
