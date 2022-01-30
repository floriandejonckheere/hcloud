# frozen_string_literal: true

module HCloud
  class CertificateStatus < Entity
    attribute :error, :error
    attribute :issuance
    attribute :renewal
  end
end
