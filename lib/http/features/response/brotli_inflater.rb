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
    module Response
      # @!visibility private
      class BrotliInflater < HTTP::Response::Inflater
        def readpartial(*args)
          chunks = []

          while (chunk = @connection.readpartial(*args))
            chunks << chunk
          end

          return if chunks.empty?

          Brotli.inflate(chunks.join)
        end
      end
    end
  end
end
