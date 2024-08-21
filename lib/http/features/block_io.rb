# frozen_string_literal: true

# @!visibility private
module HTTP
  # @!visibility private
  module Features
    # @!visibility private
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
