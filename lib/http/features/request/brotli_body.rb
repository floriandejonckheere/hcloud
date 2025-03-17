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
    module Request
      # @!visibility private
      class BrotliBody < CompressedBody
        def compress(&block)
          brotli = Brotli::Writer.new(BlockIO.new(block))
          @body.each { |chunk| brotli.write(chunk) }
        ensure
          brotli.finish
        end
      end
    end
  end
end
