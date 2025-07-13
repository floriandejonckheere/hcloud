# frozen_string_literal: true

module HCloud
  class StorageBoxAccessSettings < Entity
    attribute :reachable_externally, :boolean
    attribute :samba_enabled, :boolean
    attribute :ssh_enabled, :boolean
    attribute :webdav_enabled, :boolean
    attribute :zfs_enabled, :boolean

    alias reachable_externally? reachable_externally
    alias samba_enabled? samba_enabled
    alias ssh_enabled? ssh_enabled
    alias webdav_enabled? webdav_enabled
    alias zfs_enabled? zfs_enabled
  end
end
