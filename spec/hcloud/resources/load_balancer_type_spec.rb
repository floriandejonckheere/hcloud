# frozen_string_literal: true

RSpec.describe HCloud::LoadBalancerType, :integration, order: :defined do
  it "lists load balancer types" do
    load_balancer_types = described_class.all

    expect(load_balancer_types.count).to be > 1
  end

  it "filters load balancer types" do
    load_balancer_types = described_class.all.where(name: "lb11")

    expect(load_balancer_types.count).to eq 1
    expect(load_balancer_types.first.id).to eq 1
  end

  it "finds load balancer types" do
    load_balancer_type = described_class.find(1)

    expect(load_balancer_type.name).to eq "lb11"
    expect(load_balancer_type.description).to eq "LB11"

    expect(load_balancer_type.max_assigned_certificates).not_to be_zero
    expect(load_balancer_type.max_connections).not_to be_zero
    expect(load_balancer_type.max_services).not_to be_zero
    expect(load_balancer_type.max_targets).not_to be_zero

    price = load_balancer_type.prices.find { |p| p.location == "fsn1" }

    expect(price.included_traffic).not_to be_nil
    expect(price.price_per_tb_traffic.net).not_to be_nil

    expect(price.price_monthly.net).not_to be_nil
    expect(price.price_hourly.net).not_to be_nil

    expect(load_balancer_type.deprecated).to be_nil
  end
end
