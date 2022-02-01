# frozen_string_literal: true

RSpec.shared_context "resource" do
  class Child < HCloud::Resource
    attribute :id, :integer
    attribute :name
  end

  ActiveModel::Type.register(:child, HCloud::ResourceType.Type("Child"))

  class Sibling < HCloud::Entity
    attribute :name
    attribute :child, :child
  end

  ActiveModel::Type.register(:sibling, HCloud::ResourceType.Type("Sibling"))

  let(:resource_class) do
    Class.new(HCloud::Resource) do
      actionable
      queryable
      creatable
      updatable
      deletable

      attribute :id, :integer
      attribute :name
      attribute :description
      attribute :child, :child
      attribute :children, :child, array: true, default: -> { [] }

      attribute :sibling, :sibling

      attribute :labels, default: -> { {} }

      action :resize

      def creatable_attributes
        [:name, :description, :labels, :sibling, child: :name, children: [:id, :name]]
      end

      def updatable_attributes
        [:name, :description, :labels]
      end

      # Override resource name
      def self.resource_name
        "resource"
      end
    end
  end
end
