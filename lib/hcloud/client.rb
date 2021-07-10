# frozen_string_literal: true

module HCloud
  class Client
    class_attribute :connection

    attr_reader :token, :endpoint

    def initialize(token, endpoint = "https://api.hetzner.cloud/")
      @token = token
      @endpoint = endpoint
    end
  end
end
