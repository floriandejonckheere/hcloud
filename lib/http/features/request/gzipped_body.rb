# frozen_string_literal: true

require "zlib"

# @!visibility private
module HTTP
  # @!visibility private
  module Features
    # @!visibility private
    module Request
      # @!visibility private
      class GzippedBody < CompressedBody
        def compress(&block)
          gzip = Zlib::GzipWriter.new(BlockIO.new(block))
          @body.each { |chunk| gzip.write(chunk) }
        ensure
          gzip.finish
        end
      end
    end
  end
end
