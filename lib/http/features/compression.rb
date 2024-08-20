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
      SUPPORTED_ENCODING = Set.new(%w[deflate gzip x-gzip]).freeze

      HTTP::Options.register_feature(:compression, self)

      attr_reader :method

      def initialize(**)
        super

        @method = @opts.key?(:method) ? @opts[:method].to_s : "gzip"

        raise Error, "Only gzip and brotli methods are supported" unless %w[gzip brotli].include?(@method)
      end

      def wrap_request(request)
        return request unless method
        return request if request.body.size.zero?

        # We need to delete Content-Length header. It will be set automatically by HTTP::Request::Writer
        request.headers.delete(Headers::CONTENT_LENGTH)
        request.headers[Headers::CONTENT_ENCODING] = method

        Request.new(
          :version        => request.version,
          :verb           => request.verb,
          :uri            => request.uri,
          :headers        => request.headers,
          :proxy          => request.proxy,
          :body           => deflated_body(request.body),
          :uri_normalizer => request.uri_normalizer
        )
      end

      def wrap_response(response)
        return response unless supported_encoding?(response)

        options = {
          :status        => response.status,
          :version       => response.version,
          :headers       => response.headers,
          :proxy_headers => response.proxy_headers,
          :connection    => response.connection,
          :body          => stream_for(response.connection),
          :request       => response.request
        }

        Response.new(options)
      end

      def deflated_body(body)
        case method
        when "gzip"
          GzippedBody.new(body)
        when "brotli"
          BrotliBody.new(body)
        end
      end

      def stream_for(connection)
        Response::Body.new(Response::Inflater.new(connection))
      end

      def supported_encoding?(response)
        content_encoding = response.headers.get(Headers::CONTENT_ENCODING).first
        content_encoding && SUPPORTED_ENCODING.include?(content_encoding)
      end

      class CompressedBody < HTTP::Request::Body
        def initialize(uncompressed_body)
          @body       = uncompressed_body
          @compressed = nil
        end

        def size
          compress_all! unless @compressed
          @compressed.size
        end

        def each(&block)
          return to_enum __method__ unless block

          if @compressed
            compressed_each(&block)
          else
            compress(&block)
          end

          self
        end

        private

        def compressed_each
          while (data = @compressed.read(Connection::BUFFER_SIZE))
            yield data
          end
        ensure
          @compressed.close!
        end

        def compress_all!
          @compressed = Tempfile.new("http-compressed_body", :binmode => true)
          compress { |data| @compressed.write(data) }
          @compressed.rewind
        end
      end

      class GzippedBody < CompressedBody
        def compress(&block)
          gzip = Zlib::GzipWriter.new(BlockIO.new(block))
          @body.each { |chunk| gzip.write(chunk) }
        ensure
          gzip.finish
        end

        class BlockIO
          def initialize(block)
            @block = block
          end

          def write(data)
            @block.call(data)
          end
        end
      end
    end
  end
end
