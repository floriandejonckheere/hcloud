# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "zeitwerk"

require "byebug" if ENV["ENV"] == "development"

module HCloud
  class << self
    # Code loader instance
    attr_reader :loader

    def root
      @root ||= Pathname.new(File.expand_path(File.join("..", ".."), __FILE__))
    end

    # rubocop:disable Metrics/AbcSize
    def setup
      @loader = Zeitwerk::Loader.for_gem

      # Register inflections
      require root.join("config/inflections.rb")

      # Collapse resources
      loader.collapse(
        root.join("lib/hcloud/entities"),
        root.join("lib/hcloud/concerns"),
        root.join("lib/hcloud/resources"),
      )

      # Load types
      require root.join("lib/hcloud/resource_type")

      loader.setup
      loader.eager_load
    end
    # rubocop:enable Metrics/AbcSize
  end
end

HCloud.setup
