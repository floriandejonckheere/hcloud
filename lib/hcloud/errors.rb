# frozen_string_literal: true

module HCloud
  module Errors
    class Error < StandardError; end

    class Unauthorized < Error; end

    class Forbidden < Error; end

    class InvalidInput < Error; end

    class JSON < Error; end

    class Locked < Error; end

    class NotFound < Error; end

    class RateLimitExceeded < Error; end

    class ResourceLimitExceeded < Error; end

    class ResourceUnavailable < Error; end

    class Service < Error; end

    class Uniqueness < Error; end

    class Protected < Error; end

    class Maintenance < Error; end

    class Conflict < Error; end

    class Unsupported < Error; end

    class TokenReadonly < Error; end
  end
end
