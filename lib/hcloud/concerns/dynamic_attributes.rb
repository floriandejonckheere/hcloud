# frozen_string_literal: true

module HCloud
  module DynamicAttributes
    extend ActiveSupport::Concern

    included do
      def method_missing(name, *args) # rubocop:disable Metrics/AbcSize
        return super unless name.to_s.end_with?("=")

        # Infer attribute name
        attribute = name.to_s.chomp("=")

        return super if attribute_names.include?(attribute)

        warn "Unknown attribute: #{self.class.name}##{attribute}. Please file an issue at https://github.com/floriandejonckheere/hcloud/issues/new?title=Unknown+attribute+#{self.class.name}%23#{attribute}."

        # Add definition to class singleton
        self.class.attribute(name.to_s.chomp("=").to_sym, :string)

        # Add definition to current instance
        @attributes[name.to_s.chomp("=")] = self.class._default_attributes[name.to_s.chomp("=")].dup

        # Set attribute
        send(name, *args)
      end

      def respond_to_missing?(name, include_private = false)
        name.to_s.end_with?("=") || super
      end
    end
  end
end
