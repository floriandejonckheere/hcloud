# frozen_string_literal: true

module HCloud
  # @!visibility private
  class SubCollection
    include Enumerable

    attr_reader :name, :type, :resource, :label_selector

    def initialize(name, type, resource)
      @name = name
      @type = type
      @resource = resource
    end

    def where(label_selector: nil)
      @label_selector = label_selector

      self
    end

    def each(&block)
      return to_enum(:each) unless block

      all.each(&block)

      self
    end

    def find(id)
      raise Errors::MissingIDError unless resource.id

      subresource_class.new resource
        .client
        .get("#{resource.resource_path}/#{resource.id}/#{name.to_s.pluralize}/#{id}")
        .fetch(name)
    end

    def new(attributes = {})
      subresource_class.new attributes
        .merge(resource.resource_name => resource.id)
    end

    def create(attributes = {})
      new(attributes)
        .tap(&:create)
    end

    def inspect
      label_selector = label_selector ? " labels_selector: (#{label_selector})" : nil

      "#<#{self.class}#{label_selector} count: #{count}>"
    end

    delegate :[], :first, :last, :count, :empty?, to: :to_a

    private

    def all
      @all ||= resource
        .client
        .get("#{resource.resource_path}/#{resource.id}/#{name.to_s.pluralize}", params)
        .fetch(name.to_s.pluralize.to_sym)
        .map { |attrs| subresource_class.new attrs }
    end

    def params
      {
        label_selector: label_selector,
      }
    end

    def subresource_class
      @subresource_class ||= ActiveModel::Type
        .lookup(type)
        .resource_class
    end
  end
end
