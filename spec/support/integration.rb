# frozen_string_literal: true

RSpec.configure do |config|
  logger = Logger.new($stdout)
  logger.level = ENV.fetch("LOG_LEVEL", "warn")

  config.before(:context, integration: true) do
    @client = HCloud::Client.connection

    # Set client
    HCloud::Client.connection = HCloud::Client.new(
      access_token: ENV.fetch("HCLOUD_TOKEN"),
      logger: logger,
    )

    # Enable real HTTP connections
    WebMock.allow_net_connect!
  end

  config.after(:context, integration: true) do
    # Delete all created instances
    described_class.all.each { |i| i.try(:delete) }

    # Unset client
    HCloud::Client.connection = @client

    # Disable real HTTP connections
    WebMock.disable_net_connect!
  end
end
