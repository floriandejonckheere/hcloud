# frozen_string_literal: true

module HCloud
  module Errors
    class Error < StandardError; end

    class NotFoundError < Error; end

    class APIError < Error; end
  end
end
