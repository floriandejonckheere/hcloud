# frozen_string_literal: true

module HCloud
  class AppliedTo < ApplyTo
    attribute :applied_to_resources, :applied_to_resource, array: true, default: -> { [] }
  end
end
