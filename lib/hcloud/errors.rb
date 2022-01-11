# frozen_string_literal: true

module HCloud
  module Errors
    class ActionFailed < Error; end
    class Conflict < Error; end
    class Error < StandardError; end
    class FirewallResourceNotFound < Error; end
    class Forbidden < Error; end
    class IPNotAvailable < Error; end
    class IncompatibleNetworkType < Error; end
    class InvalidInput < Error; end
    class JSONError < Error; end
    class Locked < Error; end
    class Maintenance < Error; end
    class NetworksOverlap < Error; end
    class NoSpaceLeftInLocation < Error; end
    class NoSubnetAvailable < Error; end
    class NotFound < Error; end
    class PlacementError < Error; end
    class PlacementError < Error; end
    class Protected < Error; end
    class RateLimitExceeded < Error; end
    class ResourceLimitExceeded < Error; end
    class ResourceUnavailable < Error; end
    class ResourceInUse < Error; end
    class ServerAlreadyAdded < Error; end
    class ServerAlreadyAttached < Error; end
    class ServerError < Error; end
    class ServiceError < Error; end
    class TokenReadonly < Error; end
    class Unauthorized < Error; end
    class UniquenessError < Error; end
    class UnsupportedError < Error; end
  end
end
