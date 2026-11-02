# frozen_string_literal: true

begin
  require "brotli"

  version = Brotli::VERSION.split(".").map(&:to_i)
  raise ArgumentError, "incompatible version of brotli: #{Brotli::VERSION}, needs to be at least 0.3.0" unless version[0].positive? || version[1] >= 3
rescue LoadError
  # Ignore
end

# @!visibility private
module HTTP
  # @!visibility private
  module Features
    # @!visibility private
    class Compression < Feature
      # @!visibility private
      class BrotliInflater < HTTP::Response::Inflater
        def readpartial(*)
          chunks = []

          loop do
            chunks << @connection.readpartial(*)
          rescue EOFError
            break
          end

          # Signal end of stream when no more data is left
          raise EOFError if chunks.empty?

          Brotli.inflate(chunks.join)
        end
      end
    end
  end
end
