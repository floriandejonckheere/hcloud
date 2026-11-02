# frozen_string_literal: true

module HCloud
  class NetworkMember < Entity
    attribute :type
    attribute :id, :integer

    attribute :ip
    attribute :alias_ips, array: true, default: -> { [] }
    attribute :subnet

    attribute :status

    ##
    # The attached resource (e.g. HCloud::Server or HCloud::LoadBalancer)
    #
    def resource
      ActiveModel::Type
        .lookup(type.to_sym)
        .cast(id)
    end
  end
end
