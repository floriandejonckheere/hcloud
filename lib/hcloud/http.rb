# frozen_string_literal: true

require "logger"

require "http"

module HCloud
  class HTTP
    attr_reader :access_token, :endpoint, :logger, :timeout

    def initialize(access_token, endpoint, logger = Logger.new("/dev/null"), timeout = 10)
      @access_token = access_token
      @endpoint = endpoint
      @logger = logger
      @timeout = timeout
    end

    def get(path, params = {})
      response = http
        .get(url_for(path), params: params)

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors.const_get(data.dig(:error, :code).camelize), data.dig(:error, :message)
    end

    def put(path, body = {})
      response = http
        .put(url_for(path), json: body)

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors.const_get(data.dig(:error, :code).camelize), data.dig(:error, :message)
    end

    def post(path, body = {})
      response = http
        .post(url_for(path), json: body)

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors.const_get(data.dig(:error, :code).camelize), data.dig(:error, :message)
    end

    def delete(path)
      response = http
        .delete(url_for(path))

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors.const_get(data.dig(:error, :code).camelize), data.dig(:error, :message)
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
