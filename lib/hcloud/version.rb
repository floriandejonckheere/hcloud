# frozen_string_literal: true

module HCloud
  module Version
    MAJOR = 1
    MINOR = 0
    PATCH = 0
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  VERSION = Version::STRING
end
