# frozen_string_literal: true

RSpec.describe HCloud::DeprecatedAttributes do
  subject(:resource) { ExampleResource.new }

  it "allows deprecated attributes" do
    expect { resource.deprecated }
      .to output("[DEPRECATION] Field \"deprecated\" on ExampleResource is deprecated.\n")
      .to_stderr
  end
end
