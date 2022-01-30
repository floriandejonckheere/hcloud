# frozen_string_literal: true

RSpec.describe HCloud::Singleton do
  # `singleton_class` is reserved by RSpec
  subject(:singleton) { my_singleton_class.find }

  let(:my_singleton_class) do
    Class.new(HCloud::Resource) do
      singleton

      attribute :name

      # Override resource name
      def self.resource_name
        "singleton"
      end
    end
  end

  describe ".find" do
    it "returns a singleton" do
      stub_request(:get, "https://api.hetzner.cloud/v1/singleton")
        .to_return(body: { singleton: { name: "my_singleton" } }.to_json)

      model = my_singleton_class.find

      expect(model).to be_a my_singleton_class
      expect(model.name).to eq "my_singleton"
    end
  end
end
