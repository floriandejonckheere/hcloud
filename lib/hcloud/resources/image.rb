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
  # = Actions
  # == List actions
  #
  #     actions = HCloud::Image.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::Image.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Image.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Image.find(1).actions.where(command: "change_protection")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Image.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::Image.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Image-specific actions
  # == Change protection
  #
  #     HCloud::Image.find(1).change_protection(delete: true)
  #     # => #<HCloud::Action id: 1, ...>
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

    attribute :bound_to, :server
    attribute :created_from, :server

    # Explicitly specify created attribute, because resource is not Creatable
    attribute :created, :datetime
    attribute :deleted, :datetime
    attribute :deprecated, :datetime

    attribute :rapid_deploy

    attribute :labels, default: -> { {} }

    action :change_protection

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
