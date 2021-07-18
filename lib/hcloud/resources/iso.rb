# frozen_string_literal: true

module HCloud
  ##
  # Represents an ISO image
  #
  # == List all ISOs
  #
  #     HCloud::ISO.all
  #     # => [#<HCloud::ISO id: 7631, ...>, ...]
  #
  # == Search ISOs
  #
  #     HCloud::ISO.all.where(name: "debian-10.10.0-amd64-netinst.iso")
  #     # => #<HCloud::ISO id: 7631, ...>
  #
  # == Find ISO by ID
  #
  #     HCloud::ISO.find(1)
  #     # => #<HCloud::ISO id: 7631, ...>
  #
  class ISO < Resource
    queryable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :type
    attribute :deprecated, :datetime

    def deprecated?
      deprecated.present?
    end
  end
end
