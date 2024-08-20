# frozen_string_literal: true

module CompressionHelper
  # lib/active_support/gzip.rb
  class Stream < StringIO
    def initialize(*)
      super
      set_encoding "BINARY"
    end

    def close = rewind
  end

  # Decompresses a gzipped string.
  def decompress(source)
    Zlib::GzipReader.wrap(StringIO.new(source), &:read)
  end

  # Compresses a string using gzip.
  def compress(source, level = Zlib::DEFAULT_COMPRESSION, strategy = Zlib::DEFAULT_STRATEGY)
    output = Stream.new
    gz = Zlib::GzipWriter.new(output, level, strategy)
    gz.write(source)
    gz.close
    output.string
  end
end

RSpec.configure do |c|
  c.include CompressionHelper
end
