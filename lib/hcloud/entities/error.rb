# frozen_string_literal: true

module HCloud
  class Error < Entity
    attribute :code
    attribute :message
  end
end
