# frozen_string_literal: true

RSpec.describe HCloud::Pricing, integration: true, order: :defined do
  subject(:pricing) { described_class.find }

  it "finds the pricing" do
    expect(pricing.currency).to eq "EUR"

    # Floating IP
    expect(pricing.floating_ip.price_monthly.gross.to_f).not_to be_zero
    expect(pricing.floating_ip.price_monthly.net.to_f).not_to be_zero

    expect(pricing.floating_ips).not_to be_empty

    floating_ip = pricing.floating_ips.find { |p| p.type == "ipv4" }.prices.find { |price| price.location == "fsn1" }
    expect(floating_ip.price_monthly.gross.to_f).not_to be_zero
    expect(floating_ip.price_monthly.net.to_f).not_to be_zero

    # Image
    expect(pricing.image.price_per_gb_month.gross.to_f).not_to be_zero
    expect(pricing.image.price_per_gb_month.net.to_f).not_to be_zero

    # Load Balancer Types
    expect(pricing.load_balancer_types).not_to be_empty

    load_balancer_type = pricing.load_balancer_types.find { |lbt| lbt.name == "lb11" }
    expect(load_balancer_type.prices).not_to be_empty

    load_balancer_type_price = load_balancer_type.prices.find { |price| price.location == "fsn1" }
    expect(load_balancer_type_price.price_monthly.gross.to_f).not_to be_zero
    expect(load_balancer_type_price.price_monthly.net.to_f).not_to be_zero

    # Server Backup
    expect(pricing.server_backup.percentage.to_f).not_to be_zero

    # Server Types
    expect(pricing.server_types).not_to be_empty

    server_type_type = pricing.server_types.find { |st| st.name == "cx11" }
    expect(server_type_type.prices).not_to be_empty

    server_type_type_price = server_type_type.prices.find { |price| price.location == "fsn1" }
    expect(server_type_type_price.price_monthly.gross.to_f).not_to be_zero
    expect(server_type_type_price.price_monthly.net.to_f).not_to be_zero

    # Traffic
    expect(pricing.traffic.price_per_tb.gross.to_f).not_to be_zero
    expect(pricing.traffic.price_per_tb.net.to_f).not_to be_zero

    # VAT rate
    expect(pricing.vat_rate.to_f).not_to be_zero

    # Volume
    expect(pricing.volume.price_per_gb_month.gross.to_f).not_to be_zero
    expect(pricing.volume.price_per_gb_month.net.to_f).not_to be_zero
  end
end
