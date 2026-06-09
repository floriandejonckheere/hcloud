# frozen_string_literal: true

module HCloud
  # @!visibility private
  module DeprecatedResource
    extend ActiveSupport::Concern

    included do
      class_attribute :_deprecated, default: false
      class_attribute :deprecated_since
    end

    class_methods do # rubocop:disable Metrics/BlockLength
      def deprecated(since: nil)
        self._deprecated = true
        self.deprecated_since = Date.parse(since) if since

        [:find, :all, :create].each do |method|
          define_singleton_method(method) do |*args, **kwargs, &block|
            warn "[DEPRECATION] Resource \"#{name}\" is deprecated since #{deprecated_since.iso8601}." if deprecated?

            super(*args, **kwargs, &block)
          end
        end
      end

      def deprecated?
        _deprecated
      end

      # Wrap instance methods as they are defined (e.g. reload added by queryable)
      def method_added(method_name)
        super

        return unless _deprecated
        return unless [:reload, :update, :delete].include? method_name

        return if @_wrapping_deprecated_instance

        @_wrapping_deprecated_instance = true

        original = instance_method(method_name)

        define_method(method_name) do |*args, **kwargs, &block|
          warn "[DEPRECATION] Resource \"#{self.class.name}\" is deprecated since #{self.class.deprecated_since.iso8601}." if self.class.deprecated?

          original.bind_call(self, *args, **kwargs, &block)
        end

        @_wrapping_deprecated_instance = false
      end
    end
  end
end
