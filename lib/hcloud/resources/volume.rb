# frozen_string_literal: true

module HCloud
  ##
  # Represents a volume
  #
  # == List all volumes
  #
  #     HCloud::Volume.all
  #     # => [#<HCloud::Volume id: 1, ...>, ...]
  #
  # == Sort volumes
  #
  #     HCloud::Volume.all.sort(name: :desc)
  #     # => [#<HCloud::Volume id: 1, ...>, ...]
  #
  #     HCloud::Volume.all.sort(:id, name: :asc)
  #     # => [#<HCloud::Volume id: 1, ...>, ...]
  #
  # == Search volumes
  #
  #     HCloud::Volume.all.where(name: "my_volume")
  #     # => #<HCloud::Volume id: 1, ...>
  #
  #     HCloud::Volume.all.where(status: "available")
  #     # => #<HCloud::Volume id: 1, ...>
  #
  # == Find volume by ID
  #
  #     HCloud::Volume.find(1)
  #     # => #<HCloud::Volume id: 1, ...>
  #
  # == Create volume
  #
  #     volume = HCloud::Volume.new(name: "my_volume", size: 10, format: "ext4", automount: false, location: { name: "nbg1" })
  #     volume.create
  #     volume.created?
  #     # => true
  #
  # == Update volume
  #
  #     volume = HCloud::Volume.find(1)
  #     volume.name = "another_volume"
  #     volume.update
  #
  # == Delete volume
  #
  #     volume = HCloud::Volume.find(1)
  #     volume.delete
  #     volume.deleted?
  #     # => true
  #
  # = Actions
  # == List actions
  #
  #     actions = HCloud::Volume.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::Volume.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Volume.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Volume.find(1).actions.where(command: "create_volume")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Volume.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::Volume.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Volume-specific actions
  # == Attach a volume to a server
  #
  #     HCloud::Volume.find(1).attach(server: 1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Detach a volume from a server
  #
  #     HCloud::Volume.find(1).detach
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Resize volume
  #
  #     HCloud::Volume.find(1).resize(size: 100)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Change protection
  #
  #     HCloud::Volume.find(1).change_protection(delete: true)
  #     # => #<HCloud::Action id: 1, ...>
  #
  class Volume < Resource
    actionable
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name

    attribute :format
    attribute :size, :integer
    attribute :linux_device

    attribute :status

    attribute :automount, :boolean

    attribute :location, :location
    attribute :protection, :protection

    # TODO: return Server object
    attribute :server, :integer

    attribute :labels, default: -> { {} }

    alias automount? automount

    action :attach
    action :detach

    action :resize

    action :change_protection

    def creatable_attributes
      [:name, :format, :size, :server, :automount, :labels, location: :name]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
