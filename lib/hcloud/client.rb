# frozen_string_literal: true

module HCloud
  class Client
    class_attribute :connection

    attr_reader :access_token, :endpoint

    def initialize(access_token:, endpoint: "https://api.hetzner.cloud/v1")
      @access_token = access_token
      @endpoint = endpoint
    end

    delegate :get, :delete, to: :http

    private

    def http
      @http ||= HTTP.new(access_token, endpoint)
    end
  end
end
