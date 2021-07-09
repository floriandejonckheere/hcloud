# frozen_string_literal: true

require "zeitwerk"

module HCloud
  class << self
    # Code loader instance
    attr_reader :loader

    def root
      @root ||= Pathname.new(File.expand_path(File.join("..", ".."), __FILE__))
    end

    def setup
      @loader = Zeitwerk::Loader.for_gem

      # Register inflections
      require root.join("config/inflections.rb")

      loader.setup
      loader.eager_load
    end
  end
end

HCloud.setup
