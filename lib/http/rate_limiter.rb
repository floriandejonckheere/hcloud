# frozen_string_literal: true

# @!visibility private
module HTTP
  # @!visibility private
  class RateLimiter < Feature
    attr_reader :limit, :remaining, :reset, :at, :rate

    def initialize
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
      headers = response.headers

      return response if headers["RateLimit-Limit"].nil? || headers["RateLimit-Remaining"].nil? || headers["RateLimit-Reset"].nil?

      # Extract rate limits
      @limit = headers["RateLimit-Limit"].to_i
      @remaining = headers["RateLimit-Remaining"].to_i
      @reset = Time.at(headers["RateLimit-Reset"].to_i)

      # Extract request date
      @at = Time.parse(headers["Date"])

      # Calculate remaining increment rate
      @rate = 3600 / limit

      response
    end
  end
end

HTTP::Options.register_feature(:rate_limiter, HTTP::RateLimiter)
