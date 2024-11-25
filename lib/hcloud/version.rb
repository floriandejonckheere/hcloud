# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Version
    MAJOR = 3
    MINOR = 0
    PATCH = 0
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  NAME = "hetznercloud"
  VERSION = Version::STRING
end
