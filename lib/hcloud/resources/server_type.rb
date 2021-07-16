# frozen_string_literal: true

module HCloud
  class ServerType < Resource
    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :cores, :integer
    attribute :disk, :integer
    attribute :memory, :integer

    attribute :cpu_type
    attribute :storage_type

    attribute :prices, :price, array: true

    attribute :deprecated, :boolean

    # TODO: Split up Resource into read-only and read-write resources
    def delete; end
  end
end
