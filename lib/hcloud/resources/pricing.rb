# frozen_string_literal: true

module HCloud
  ##
  # Represents pricing
  #
  # == Find pricing
  #
  #     HCloud::Pricing.find
  #     # => #<HCloud::Pricing ...>
  #
  class Pricing < Resource
    singleton

    attribute :currency

    attribute :floating_ip, :floating_ip_price
    attribute :floating_ips, :floating_ip_prices, array: true, default: -> { [] }

    attribute :image, :image_price

    attribute :load_balancer_types, :load_balancer_type_price, array: true, default: -> { [] }

    attribute :primary_ips, :primary_ip_prices, array: true, default: -> { [] }

    attribute :server_backup, :server_backup_price

    attribute :server_types, :server_type_price, array: true, default: -> { [] }

    attribute :traffic, :traffic_price, deprecated: true

    attribute :vat_rate

    attribute :volume, :volume_price
  end
end
