# frozen_string_literal: true

require "logger"

module HCloud
  # @!visibility private
  class NilConnection
    def raise_error(...)
      raise ArgumentError, "no default client configured, set HCloud::Client.connection to an instance of HCloud::Client"
    end

    alias get raise_error
    alias put raise_error
    alias post raise_error
    alias delete raise_error
  end

  # @!visibility private
  class Client
    class_attribute :connection

    self.connection = NilConnection.new

    attr_reader :access_token, :endpoint, :logger, :rate_limit, :timeout, :compression

    def initialize(access_token:, endpoint: "https://api.hetzner.cloud/v1", logger: Logger.new(File::NULL), rate_limit: false, timeout: 10, compression: nil)
      @access_token = access_token
      @endpoint = endpoint
      @logger = logger
      @rate_limit = rate_limit
      @timeout = timeout
      @compression = compression
    end

    delegate :get, :put, :post, :delete, to: :http

    private

    def http
      @http ||= HTTP.new(access_token, endpoint, logger, rate_limit, timeout, compression)
    end
  end
end
