# frozen_string_literal: true

require "http"

module HCloud
  class HTTP
    attr_reader :access_token, :endpoint, :logger, :timeout

    def initialize(access_token, endpoint, logger, timeout = 10)
      @access_token = access_token
      @endpoint = endpoint
      @logger = logger
      @timeout = timeout
    end

    def get(path, params = {})
      response = http
        .get(url_for(path), params: transform_params(params))

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors::Error, data[:error]
    end

    def put(path, body = {})
      response = http
        .put(url_for(path), json: body)

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors::Error, data[:error]
    end

    def post(path, body = {})
      response = http
        .post(url_for(path), json: body)

      data = response
        .parse(:json)
        .deep_symbolize_keys

      return data if response.status.success?

      raise Errors::Error, data[:error]
    end

    def delete(path)
      response = http
        .delete(url_for(path))

      return if response.status.success?

      data = response
        .parse(:json)
        .deep_symbolize_keys

      raise Errors::Error, data[:error]
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
