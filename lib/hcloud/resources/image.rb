# frozen_string_literal: true

module HCloud
  ##
  # Represents a image
  #
  # == List all images
  #
  #     HCloud::Image.all
  #     # => [#<HCloud::Image id: 1, ...>, ...]
  #
  # == Sort images
  #
  #     HCloud::Image.all.sort(name: :desc)
  #     # => [#<HCloud::Image id: 1, ...>, ...]
  #
  #     HCloud::Image.all.sort(:id, name: :asc)
  #     # => [#<HCloud::Image id: 1, ...>, ...]
  #
  # == Search images
  #
  #     HCloud::Image.all.where(name: "my_image")
  #     # => #<HCloud::Image id: 1, ...>
  #
  #     HCloud::Image.all.where(status: "available", include_deprecated: false)
  #     # => #<HCloud::Image id: 1, ...>
  #
  #     HCloud::Image.all.where(type: "backup", bound_to: 1)
  #     # => #<HCloud::Image id: 1, ...>
  #
  # == Find image by ID
  #
  #     HCloud::Image.find(1)
  #     # => #<HCloud::Image id: 1, ...>
  #
  # == Update image
  #
  #     image = HCloud::Image.find(1)
  #     image.type = "snapshot"
  #     image.description = "#{image.description} (snapshot)"
  #     image.update
  #
  # == Delete image
  #
  #     image = HCloud::Image.find(1)
  #     image.delete
  #     image.deleted?
  #     # => true
  #
  # TODO: actions
  #
  class Image < Resource
    actionable
    queryable
    updatable
    deletable

    attribute :id, :integer
    attribute :name
    attribute :description

    attribute :type
    attribute :status

    attribute :build_id

    attribute :disk_size, :integer
    attribute :image_size, :integer

    attribute :os_flavor
    attribute :os_version

    attribute :protection, :protection

    # TODO: return Server object
    attribute :bound_to, :integer

    # TODO: return Server object
    attribute :created_from

    # Explicitly specify created attribute, because resource is not Creatable
    attribute :created, :datetime
    attribute :deleted, :datetime
    attribute :deprecated, :datetime

    attribute :rapid_deploy

    attribute :labels, default: -> { {} }

    def created?
      created.present?
    end

    def deleted?
      deleted.present?
    end

    def deprecated?
      deprecated.present?
    end

    def rapid_deploy?
      rapid_deploy.present?
    end

    def updatable_attributes
      [:description, :type, :labels]
    end
  end
end
