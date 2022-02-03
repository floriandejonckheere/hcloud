# frozen_string_literal: true

module HCloud
  class HealthCheckHTTP < Entity
    attribute :domain
    attribute :path
    attribute :response
    attribute :status_code, array: true, default: -> { [] }
    attribute :tls

    alias tls? tls
  end
end
