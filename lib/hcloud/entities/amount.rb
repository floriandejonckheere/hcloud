# frozen_string_literal: true

module HCloud
  class Amount < Entity
    attribute :gross, :decimal
    attribute :net, :decimal
  end
end
