# frozen_string_literal: true

# @!visibility private
module HTTP
  # @!visibility private
  class RateLimiter < Feature
    attr_reader :limit, :remaining, :reset, :at, :rate

    def initialize(...)
      super

      @limit = Float::INFINITY
      @remaining = Float::INFINITY
      @reset = Time.at(0)
      @at = Time.at(0)
      @rate = 1
    end

    def wrap_request(request)
      sleep rate while remaining.zero? && (at + rate).future?

      request
    end

    def wrap_response(response)
      return response if response["RateLimit-Limit"].nil? || response["RateLimit-Remaining"].nil? || response["RateLimit-Reset"].nil?

      # Extract rate limits
      @limit = response["RateLimit-Limit"].to_i
      @remaining = response["RateLimit-Remaining"].to_i
      @reset = Time.at(response["RateLimit-Reset"].to_i)

      # Extract request date
      @at = Time.parse(response.headers["Date"])

      # Calculate remaining increment rate
      @rate = 3600 / limit

      response
    end
  end
end

HTTP::Options.register_feature(:rate_limiter, HTTP::RateLimiter)
