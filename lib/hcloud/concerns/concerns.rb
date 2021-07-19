# frozen_string_literal: true

module HCloud
  module Concerns
    extend ActiveSupport::Concern

    included do
      include Associatable
    end

    class_methods do
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
    end
  end
end
