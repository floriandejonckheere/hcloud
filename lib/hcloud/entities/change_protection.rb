# frozen_string_literal: true

module HCloud
  class ChangeProtection < Entity
    attribute :change, :boolean

    alias change? change
  end
end
