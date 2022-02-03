# frozen_string_literal: true

module HCloud
  class HealthCheck < Entity
    attribute :http, :health_check_http
    attribute :interval, :integer
    attribute :port, :integer
    attribute :protocol
    attribute :retries, :integer
    attribute :timeout, :integer
  end
end
