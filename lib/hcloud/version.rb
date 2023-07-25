# frozen_string_literal: true

module HCloud
  module Version
    MAJOR = 1
    MINOR = 7
    PATCH = 1
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  NAME = "hetznercloud"
  VERSION = Version::STRING
end
