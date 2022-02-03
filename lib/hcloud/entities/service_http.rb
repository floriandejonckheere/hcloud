# frozen_string_literal: true

module HCloud
  class ServiceHTTP < Entity
    attribute :certificates, :certificate, array: true, default: -> { [] }

    attribute :cookie_lifetime, :integer
    attribute :cookie_name

    attribute :redirect_http, :boolean
    attribute :sticky_sessions, :boolean

    alias redirect_http? redirect_http
    alias sticky_sessions? sticky_sessions
  end
end
