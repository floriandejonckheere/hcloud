# frozen_string_literal: true

require "logger"

module HCloud
  class Client
    class_attribute :connection

    attr_reader :access_token, :endpoint, :logger

    def initialize(access_token:, endpoint: "https://api.hetzner.cloud/v1", logger: Logger.new("/dev/null"))
      @access_token = access_token
      @endpoint = endpoint
      @logger = logger
    end

    delegate :get, :put, :post, :delete, to: :http

    private

    def http
      @http ||= HTTP.new(access_token, endpoint, logger)
    end
  end
end
