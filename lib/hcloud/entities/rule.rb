# frozen_string_literal: true

module HCloud
  class Rule < Entity
    attribute :description

    attribute :source_ips, array: true, default: -> { [] }
    attribute :destination_ips, array: true, default: -> { [] }

    attribute :port
    attribute :protocol

    attribute :direction
  end
end
