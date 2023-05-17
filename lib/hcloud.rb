# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "zeitwerk"

module HCloud
  class << self
    # Code loader instance
    attr_reader :loader

    def root
      @root ||= Pathname.new(File.expand_path(File.join("..", ".."), __FILE__))
    end

    def setup
      @loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)

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
  end
end

HCloud.setup
