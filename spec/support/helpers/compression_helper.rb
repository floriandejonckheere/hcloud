# frozen_string_literal: true

module CompressionHelper
  def compress(source, method)
    case method
    when :gzip
      Zlib.gzip(source)
    when :brotli
      Brotli.deflate(source)
    end
  end

  def decompress(source, method)
    case method
    when :gzip
      Zlib.gunzip(source)
    when :brotli
      Brotli.inflate(source)
    end
  end
end

RSpec.configure do |c|
  c.include CompressionHelper
end
