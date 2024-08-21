# frozen_string_literal: true

require "zlib"

begin
  require "brotli"
rescue LoadError
  # Ignore
end

# @!visibility private
module HTTP
  # @!visibility private
  module Features
    # @!visibility private
    class Compression < Feature
      SUPPORTED_ENCODING = ["gzip"].freeze

      HTTP::Options.register_feature(:compression, self)

      attr_reader :method

      def initialize(**)
        super

        @method = @opts.fetch(:method, "gzip").to_s || "gzip"

        raise Error, "Only gzip method is supported" unless SUPPORTED_ENCODING.include?(method)
      end

      def wrap_request(request)
        return request unless method
        return request if request.body.size.zero? # rubocop:disable Style/ZeroLengthPredicate

        # Delete Content-Length header, it is set automatically by HTTP::Request::Writer
        request.headers.delete(Headers::CONTENT_LENGTH)

        # Set Content-Encoding header
        request.headers[Headers::CONTENT_ENCODING] = method

        HTTP::Request.new(
          version: request.version,
          verb: request.verb,
          uri: request.uri,
          headers: request.headers,
          proxy: request.proxy,
          body: compress(request.body),
          uri_normalizer: request.uri_normalizer,
        )
      end

      def wrap_response(response)
        return response unless SUPPORTED_ENCODING.include? response.headers.get(Headers::CONTENT_ENCODING).first

        HTTP::Response.new(
          status: response.status,
          version: response.version,
          headers: response.headers,
          proxy_headers: response.proxy_headers,
          connection: response.connection,
          body: decompress(response.connection),
          request: response.request,
        )
      end

      private

      def compress(body)
        case method
        when "gzip"
          Request::GzippedBody.new(body)
        end
      end

      def decompress(connection)
        case method
        when "gzip"
          HTTP::Response::Body.new(Response::GzipInflater.new(connection))
        end
      end
    end
  end
end
