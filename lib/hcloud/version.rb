# frozen_string_literal: true

module HCloud
  # @!visibility private
  module Version
    MAJOR = 5
    MINOR = 0
    PATCH = 1
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  NAME = "hetznercloud"
  VERSION = Version::STRING
end
