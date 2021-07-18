# frozen_string_literal: true

module HCloud
  ##
  # Represents a SSH key
  #
  # == List all SSH keys
  #
  #     HCloud::SSHKey.all
  #     # => [#<HCloud::SSHKey id: 1, ...>, ...]
  #
  # == Sort SSH keys
  #
  #     HCloud::SSHKey.all.sort(name: :desc)
  #     # => [#<HCloud::SSHKey id: 1, ...>, ...]
  #
  #     HCloud::SSHKey.all.sort(:id, name: :asc)
  #     # => [#<HCloud::SSHKey id: 1, ...>, ...]
  #
  # == Search SSH keys
  #
  #     HCloud::SSHKey.all.where(name: "cx11")
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  #     HCloud::SSHKey.all.where(fingerprint: "B6:6C:CD:DA:A2:24:43:39:98:80:0F:F5:51:17:7E")
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  # == Find SSH key by ID
  #
  #     HCloud::SSHKey.find(1)
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  # == Create SSH key
  #
  #     ssh_key = HCloud::SSHKey.new(name: "My SSH key", public_key: File.read("id_rsa.pub"))
  #     ssh_key.create
  #     ssh_key.created?
  #     # => true
  #
  # == Update SSH key
  #
  #     ssh_key = HCloud::SSHKey.find(1)
  #     ssh_key.name = "Another SSH key"
  #     ssh_key.update
  #
  # == Delete SSH key
  #
  #     ssh_key = HCloud::SSHKey.find(1)
  #     ssh_key.delete
  #     ssh_key.deleted?
  #     # => true
  #
  class SSHKey < Resource
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name
    attribute :public_key
    attribute :fingerprint

    attribute :labels, default: -> { {} }

    def creatable_attributes
      [:name, :public_key, :labels]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
