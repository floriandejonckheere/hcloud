# frozen_string_literal: true

module HCloud
  class Service < Entity
    attribute :listen_port, :integer
    attribute :destination_port, :integer

    attribute :protocol
    attribute :proxyprotocol, :boolean

    attribute :health_check, :health_check
    attribute :http, :service_http

    alias proxyprotocol? proxyprotocol
  end
end
