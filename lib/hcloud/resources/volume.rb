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
  #     HCloud::Volume.sort(name: :desc)
  #     # => [#<HCloud::Volume id: 1, ...>, ...]
  #
  #     HCloud::Volume.sort(:id, name: :asc)
  #     # => [#<HCloud::Volume id: 1, ...>, ...]
  #
  # == Search volumes
  #
  #     HCloud::Volume.where(name: "my_volume")
  #     # => #<HCloud::Volume id: 1, ...>
  #
  #     HCloud::Volume.where(status: "available")
  #     # => #<HCloud::Volume id: 1, ...>
  #
  #     HCloud::Volume.where(label_selector: { environment: "production" })
  #     # => #<HCloud::Volume id: 1, ...>
  #
  # == Find volume by ID
  #
  #     HCloud::Volume.find(1)
  #     # => #<HCloud::Volume id: 1, ...>
  #
  # == Create volume
  #
  #     volume = HCloud::Volume.new(name: "my_volume", size: 10, format: "ext4", automount: false, location: "fsn1")
  #     volume.create
  #     volume.created?
  #     # => true
  #
  #     volume = HCloud::Volume.create(name: "my_volume", size: 10, format: "ext4", automount: false, location: "fsn1")
  #     # => #<HCloud::Volume id: 1, ...>
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
  # = Resource-specific actions
  # == Attach a volume to a server
  #
  #     HCloud::Volume.find(1).attach(server: 1, automount: false)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Detach a volume from a server
  #
  #     HCloud::Volume.find(1).detach
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Resize volume
  #
  #     HCloud::Volume.find(1).resize(size: 25)
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
    labelable

    attribute :id, :integer
    attribute :name

    attribute :format
    attribute :size, :integer
    attribute :linux_device

    attribute :status

    attribute :automount, :boolean

    attribute :location, :location
    attribute :protection, :protection

    attribute :server, :server

    alias automount? automount

    action :attach
    action :detach

    action :resize

    action :change_protection

    def creatable_attributes
      [:name, :format, :size, :server, :automount, :labels, location: [:id, :name]]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
