# frozen_string_literal: true

module HCloud
  class SSHKey < Resource
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name
    attribute :public_key
    attribute :fingerprint

    attribute :labels, default: -> { {} }

    attribute :created, :datetime

    def creatable_attributes
      [:name, :public_key, :labels]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
