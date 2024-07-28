# frozen_string_literal: true

module HCloud
  # @!visibility private
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

      def meterable
        include Meterable
      end

      def singleton
        include Singleton
      end

      def labelable
        include Labelable
      end
    end
  end
end
