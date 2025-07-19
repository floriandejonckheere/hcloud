# frozen_string_literal: true

module HCloud
  class StorageBoxSubaccountAccessSettings < Entity
    attribute :samba_enabled, :boolean
    attribute :ssh_enabled, :boolean
    attribute :webdav_enabled, :boolean

    attribute :readonly, :boolean
    attribute :reachable_externally, :boolean

    alias samba_enabled? samba_enabled
    alias ssh_enabled? ssh_enabled
    alias webdav_enabled? webdav_enabled

    alias readonly? readonly
    alias reachable_externally? reachable_externally
  end
end
