# frozen_string_literal: true

require "logger"

require "http"

module HCloud
  class HTTP
    attr_reader :endpoint, :access_token, :logger, :timeout

    def initialize(endpoint, access_token, logger = Logger.new("/dev/null"), timeout = 10)
      @endpoint = endpoint
      @access_token = access_token
      @logger = logger
      @timeout = timeout
    end

    def get(path, params = {})
      response = http
        .get(url_for(path), params: params)

      raise Errors::NotFoundError, response if response.code == 404
      raise Errors::APIError, response unless response.status.success?

      response
        .parse(:json)
    end

    private

    def http
      @http ||= ::HTTP
        .headers(accept: "application/json", user_agent: "#{HCloud::NAME}/#{HCloud::VERSION}")
        .timeout(timeout)
        .use(logging: { logger: logger })
        .encoding("utf-8")
        .auth("Bearer #{access_token}")
    end

    def url_for(path)
      "#{endpoint}#{path}"
    end
  end
end
