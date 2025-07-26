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
  #     HCloud::SSHKey.sort(name: :desc)
  #     # => [#<HCloud::SSHKey id: 1, ...>, ...]
  #
  #     HCloud::SSHKey.sort(:id, name: :asc)
  #     # => [#<HCloud::SSHKey id: 1, ...>, ...]
  #
  # == Search SSH keys
  #
  #     HCloud::SSHKey.where(name: "cx11")
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  #     HCloud::SSHKey.where(fingerprint: "B6:6C:CD:DA:A2:24:43:39:98:80:0F:F5:51:17:7E")
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  #     HCloud::SSHKey.where(label_selector: "environment=production")
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  # == Find SSH key by ID
  #
  #     HCloud::SSHKey.find(1)
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  # == Create SSH key
  #
  #     ssh_key = HCloud::SSHKey.new(name: "my_ssh_key", public_key: File.read("id_rsa.pub"))
  #     ssh_key.create
  #     ssh_key.created?
  #     # => true
  #
  #     firewall = HCloud::SSHKey.create(name: "my_ssh_key", public_key: File.read("id_rsa.pub"))
  #     # => #<HCloud::SSHKey id: 1, ...>
  #
  # == Update SSH key
  #
  #     ssh_key = HCloud::SSHKey.find(1)
  #     ssh_key.name = "another_ssh_key"
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
    labelable

    attribute :id, :integer
    attribute :name
    attribute :public_key
    attribute :fingerprint

    def creatable_attributes
      [:name, :public_key, :labels]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
