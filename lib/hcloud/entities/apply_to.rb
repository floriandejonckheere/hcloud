# frozen_string_literal: true

module HCloud
  class ApplyTo < Entity
    attribute :type

    attribute :server, :server
    attribute :label_selector

    def to_h
      # Omit `label_selector` if type is `server` and vice versa
      super.except(type == "server" ? "label_selector" : "server")
    end
  end
end
