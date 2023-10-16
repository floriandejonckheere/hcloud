# frozen_string_literal: true

RSpec.describe HCloud::LoadBalancer, :integration, order: :defined do
  id_one, id_two = nil

  it "creates a load balancer" do
    load_balancer = described_class.new(name: "first", algorithm: { type: "round_robin" }, load_balancer_type: "lb11", location: "nbg1")

    load_balancer.create

    expect(load_balancer).to be_created
    expect(load_balancer.id).not_to be_nil

    id_one = load_balancer.id
  end

  it "creates another load balancer" do
    load_balancer = described_class.new(name: "second", algorithm: { type: "round_robin" }, load_balancer_type: "lb11", location: "nbg1")

    load_balancer.create

    expect(load_balancer).to be_created
    expect(load_balancer.id).not_to be_nil

    id_two = load_balancer.id
  end

  it "finds an load balancer" do
    load_balancer = described_class.find(id_one)

    expect(load_balancer.name).to eq "first"

    expect(load_balancer.algorithm.type).to eq "round_robin"
    expect(load_balancer.load_balancer_type.name).to eq "lb11"

    expect(load_balancer.included_traffic).not_to be_zero
    expect(load_balancer.ingoing_traffic).to be_nil
    expect(load_balancer.outgoing_traffic).to be_nil

    expect(load_balancer.location.name).to eq "nbg1"

    expect(load_balancer.private_net).to be_nil
    expect(load_balancer.public_net).to be_enabled

    # TODO: create services and targets
    expect(load_balancer.services).to be_empty
    expect(load_balancer.targets).to be_empty

    expect(load_balancer.protection).not_to be_delete

    expect(load_balancer.labels).to be_empty
  end

  it "lists load balancers" do
    load_balancers = described_class.all

    expect(load_balancers.count).to eq 2
    expect(load_balancers.map(&:id)).to contain_exactly(id_one, id_two)
  end

  it "sorts load balancers" do
    load_balancers = described_class.all.sort(name: :desc)

    expect(load_balancers.count).to eq 2
    expect(load_balancers.map(&:id)).to eq [id_two, id_one]
  end

  it "filters load balancers" do
    load_balancers = described_class.all.where(name: "first")

    expect(load_balancers.count).to eq 1
    expect(load_balancers.first.id).to eq id_one
  end

  it "updates a load balancer" do
    load_balancer = described_class.find(id_one)

    load_balancer.name = "third"

    load_balancer.update

    load_balancer = described_class.find(id_one)

    expect(load_balancer.name).to eq "third"
  end

  it "deletes a load balancer" do
    load_balancer = described_class.find(id_one)

    load_balancer.delete

    expect(load_balancer).to be_deleted

    expect { described_class.find(id_one) }.to raise_error HCloud::Errors::NotFound
  end

  it "retrieves metrics" do
    load_balancer = described_class.find(id_two)

    metrics = load_balancer.metrics(type: :bandwidth, from: 1.minute.ago, to: 1.second.ago)

    expect(metrics).not_to be_nil
  end
end
