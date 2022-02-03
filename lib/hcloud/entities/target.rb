# frozen_string_literal: true

module HCloud
  class Target < Entity
    attribute :type

    attribute :health_status, :health_status, array: true, default: -> { [] }

    attribute :server, :server

    attribute :use_private_ip, :boolean

    alias use_private_ip? use_private_ip
  end
end
