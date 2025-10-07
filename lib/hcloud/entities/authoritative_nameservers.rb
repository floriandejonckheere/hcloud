# frozen_string_literal: true

module HCloud
  class AuthoritativeNameservers < Entity
    attribute :assigned, array: true, default: -> { [] }
    attribute :delegated, array: true, default: -> { [] }
    attribute :delegation_last_check, :datetime
    attribute :delegation_status
  end
end
