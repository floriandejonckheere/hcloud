# frozen_string_literal: true

require "http"

module HCloud
  # @!visibility private
  class HTTP
    # Supported compression algorithms
    COMPRESSION_ALGORITHMS = [
      "gzip",
    ].freeze

    attr_reader :access_token, :endpoint, :logger, :rate_limit, :timeout, :compression

    def initialize(access_token, endpoint, logger, rate_limit = false, timeout = 10, compression = nil)
      raise ArgumentError, "invalid compression algorithm: #{compression}" if compression && !COMPRESSION_ALGORITHMS.include?(compression)

      @access_token = access_token
      @endpoint = endpoint
      @logger = logger
      @rate_limit = rate_limit
      @timeout = timeout
      @compression = compression
    end

    def get(path, params = {})
      response = http
        .get(url_for(path), params: transform_params(params))

      raise Errors::ServerError, response if response.status.server_error?

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors.const_get(data.dig(:error, :code).camelize), data[:error]
    end

    def put(path, body = {})
      response = http
        .put(url_for(path), json: body)

      raise Errors::ServerError, response if response.status.server_error?

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors.const_get(data.dig(:error, :code).camelize), data[:error]
    end

    def post(path, body = {})
      response = http
        .post(url_for(path), json: body)

      raise Errors::ServerError, response if response.status.server_error?

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors.const_get(data.dig(:error, :code).camelize), data[:error]
    end

    def delete(path)
      response = http
        .delete(url_for(path))

      return if response.status.success?

      raise Errors::ServerError, response if response.status.server_error?

      data = response
        .parse(:json)
        .deep_symbolize_keys

      raise Errors.const_get(data.dig(:error, :code).camelize), data[:error]
    end

    private

    def http
      @http ||= ::HTTP
        .headers(user_agent: "#{HCloud::NAME}/#{HCloud::VERSION}", "Accept-Encoding" => compression)
        .accept("application/json")
        .timeout(timeout)
        .use(logging: { logger: logger })
        .then { |h| rate_limit ? h.use(:rate_limiter) : h }
        .then { |h| compression ? h.use(:auto_deflate, :auto_inflate) : h }
        .encoding("utf-8")
        .auth("Bearer #{access_token}")
    end

    def url_for(path)
      "#{endpoint}#{path}"
    end

    def transform_params(params)
      params
        .transform_values do |value|
        # Don't transform if value is single argument: { sort: :id }
        next value unless value.respond_to?(:each)

        value.map do |element|
          # Don't transform if element is single argument: { sort: [:id] }
          next element unless element.respond_to?(:each)

          # Join elements with : { sort: [id: :asc] }
          element.to_a.join(":")
        end
      end
        .compact
    end
  end
end
