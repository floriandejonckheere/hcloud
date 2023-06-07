# frozen_string_literal: true

module HCloud
  class PublicNetFirewall < Entity
    attribute :id, :integer
    attribute :status

    def applied?
      status == "applied"
    end

    def pending?
      status == "pending"
    end
  end
end
