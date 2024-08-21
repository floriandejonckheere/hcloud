# frozen_string_literal: true

require "zlib"

# @!visibility private
module HTTP
  # @!visibility private
  module Features
    # @!visibility private
    module Response
      # @!visibility private
      class GzipInflater < HTTP::Response::Inflater
      end
    end
  end
end
