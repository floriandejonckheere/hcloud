# frozen_string_literal: true

module HCloud
  ##
  # Server metadata.
  #
  # This resource allows a Hetzner server to retrieve metadata about itself.
  # It cannot be used outside of Hetzner servers.
  #
  # == Find metadata
  #
  #     HCloud::Metadata.find
  #     # => #<HCloud::Metadata ...>
  #
  class Metadata < Resource
    ENDPOINT = "https://169.254.169.254/hetzner/v1/metadata"

    attribute :hostname
    attribute :instance_id, :integer
    attribute :public_ipv4
    attribute :availability_zone
    attribute :region

    attribute :private_networks, :private_network, array: true, default: -> { [] }

    def self.find
      new(::HTTP
        .get(ENDPOINT)
        .parse(:yaml)
        .deep_transform_keys { |key| key.underscore.to_sym })
    end
  end
end
