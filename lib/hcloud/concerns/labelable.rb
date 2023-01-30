# frozen_string_literal: true

module HCloud
  module Labelable
    extend ActiveSupport::Concern

    included do
      attribute :labels, default: -> { {} }
    end
  end
end
