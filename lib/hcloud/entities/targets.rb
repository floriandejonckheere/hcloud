# frozen_string_literal: true

module HCloud
  class Targets < Target
    attribute :type

    attribute :ip, :target_ip

    attribute :label_selector, :label_selector

    attribute :targets, :target, array: true, default: -> { [] }
  end
end
