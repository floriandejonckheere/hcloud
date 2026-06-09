# frozen_string_literal: true

RSpec.describe HCloud::DeprecatedResource do
  subject(:resource) { resource_class.new(id: 1) }

  let(:resource_class) { DeprecatedExampleResource }

  it "defines deprecated? method" do
    expect(resource_class).to be_deprecated
  end

  describe "class methods" do
    [[:find, 1], [:all], [:create]].each do |method, *args|
      it "redefines #{method.inspect}" do
        stub_request(:get, "https://api.hetzner.cloud/v1/deprecated_example_resources/1")
          .to_return(body: { deprecated_example_resource: resource.attributes.merge(id: 1) }.to_json)

        stub_request(:get, "https://api.hetzner.cloud/v1/deprecated_example_resources")
          .to_return(body: { deprecated_example_resources: [resource.attributes], meta: { pagination: { total_entries: 1 } } }.to_json)

        stub_request(:post, "https://api.hetzner.cloud/v1/deprecated_example_resources")
          .to_return(body: { deprecated_example_resources: [resource.attributes], meta: { pagination: { total_entries: 1 } } }.to_json)

        expect { resource_class.public_send(method, *args) }
          .to output("[DEPRECATION] Resource \"DeprecatedExampleResource\" is deprecated since 2026-01-01.\n")
          .to_stderr
      end
    end
  end

  describe "instance methods" do
    [:reload, :update, :delete].each do |method|
      it "redefines #{method.inspect}" do
        stub_request(:get, "https://api.hetzner.cloud/v1/deprecated_example_resources/1")
          .to_return(body: { deprecated_example_resource: resource.attributes.merge(id: 1) }.to_json)

        stub_request(:put, "https://api.hetzner.cloud/v1/deprecated_example_resources/1")
          .to_return(body: { deprecated_example_resource: resource.attributes.merge(id: 1) }.to_json)

        stub_request(:delete, "https://api.hetzner.cloud/v1/deprecated_example_resources/1")

        expect { resource.public_send(method) }
          .to output("[DEPRECATION] Resource \"DeprecatedExampleResource\" is deprecated since 2026-01-01.\n")
          .to_stderr
      end
    end
  end
end
