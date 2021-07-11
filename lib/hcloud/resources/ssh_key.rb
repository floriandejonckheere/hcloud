# frozen_string_literal: true

module HCloud
  class SSHKey < Resource
    attribute :id, :integer
    attribute :name
    attribute :public_key
    attribute :fingerprint
    attribute :labels, default: -> { {} }
    attribute :created, :datetime

    def creatable_attributes
      [:name, :public_key, :labels]
    end
  end
end
