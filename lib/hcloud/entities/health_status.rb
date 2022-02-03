# frozen_string_literal: true

module HCloud
  class HealthStatus < Entity
    attribute :listen_port, :integer
    attribute :status
  end
end
