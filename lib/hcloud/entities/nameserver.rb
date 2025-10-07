# frozen_string_literal: true

module HCloud
  class Nameserver < Entity
    attribute :address
    attribute :port, :integer

    attribute :tsig_key
    attribute :tsig_algorithm
  end
end
