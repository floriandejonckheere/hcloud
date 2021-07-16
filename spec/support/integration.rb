# frozen_string_literal: true

RSpec.configure do |config|
  config.before(integration: true) do
    # Set client
    HCloud::Client.connection = HCloud::Client.new(access_token: ENV.fetch("HCLOUD_TOKEN"))

    # Enable real HTTP connections
    WebMock.allow_net_connect!
  end

  config.after(integration: true) do
    # Delete all created instances
    described_class.all.each(&:delete)

    # Unset client
    HCloud::Client.connection = nil

    # Disable real HTTP connections
    WebMock.disable_net_connect!
  end
end
