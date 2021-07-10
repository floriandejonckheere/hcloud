# frozen_string_literal: true

module HCloud
  class SSHKey < Resource
    attribute :id
    attribute :name
    attribute :public_key
    attribute :fingerprint
    attribute :labels
    attribute :created
  end
end
