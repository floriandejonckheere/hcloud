# frozen_string_literal: true

# @!visibility private
module HTTP
  # @!visibility private
  module Features
    # @!visibility private
    module Request
      # @!visibility private
      class CompressedBody < HTTP::Request::Body
        def initialize(uncompressed_body) # rubocop:disable Lint/MissingSuper
          @body = uncompressed_body
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

        def compress(&_block)
          raise NotImplementedError
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
          @compressed = Tempfile.new("http-compressed_body", binmode: true)
          compress { |data| @compressed.write(data) }
          @compressed.rewind
        end
      end
    end
  end
end
