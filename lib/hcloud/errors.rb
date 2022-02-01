# frozen_string_literal: true

module HCloud
  module Errors
    class Error < StandardError
      attr_reader :data

      def initialize(data = {})
        @data = data

        super [data[:message], full_messages&.join("\n")].compact.join("\n\n")
      end

      def full_messages
        return unless data[:details]

        data[:details][:fields].flat_map do |field|
          Array(field.fetch(:messages, data[:message])).map do |detail|
            "#{field[:name]} #{detail}"
          end
        end
      end
    end

    class ActionFailed < Error; end
    class Conflict < Error; end
    class FirewallAlreadyApplied < Error; end
    class FirewallAlreadyRemoved < Error; end
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
    class ResourceInUse < Error; end
    class ResourceLimitExceeded < Error; end
    class ResourceUnavailable < Error; end
    class ServerAlreadyAdded < Error; end
    class ServerAlreadyAttached < Error; end
    class ServerError < Error; end
    class ServiceError < Error; end
    class TokenReadonly < Error; end
    class Unauthorized < Error; end
    class UniquenessError < Error; end
    class UnsupportedError < Error; end

    class MissingIDError < Error; end
  end
end
