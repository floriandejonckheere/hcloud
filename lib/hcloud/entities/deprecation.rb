# frozen_string_literal: true

module HCloud
  class Deprecation < Entity
    attribute :announced, :datetime
    attribute :unavailable_after, :datetime
  end
end
