# frozen_string_literal: true

module HCloud
  class Metrics < Entity
    attribute :start, :datetime
    attribute :end, :datetime

    attribute :step, :integer

    attribute :time_series
  end
end
