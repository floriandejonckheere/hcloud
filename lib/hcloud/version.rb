# frozen_string_literal: true

module HCloud
  module Version
    MAJOR = 1
    MINOR = 3
    PATCH = 1
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  NAME = "hcloud"
  VERSION = Version::STRING
end
