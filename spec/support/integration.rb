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

    # Disable logging for cleanup
    logger.level = :warn

    # Clean up cloud resources
    # HCloud::Server.all.each(&:delete)
    # HCloud::PlacementGroup.all.each(&:delete)
    # HCloud::Firewall.all.each(&:delete)
    # HCloud::SSHKey.all.each(&:delete)

    # Enable logging for tests
    logger.level = ENV.fetch("LOG_LEVEL", "warn")
  end

  config.after(:context, integration: true) do
    # Disable logging for cleanup
    logger.level = :warn

    # Clean up cloud resources
    HCloud::Certificate.all.each(&:delete)
    HCloud::Server.all.each(&:delete)
    HCloud::Network.all.each(&:delete)
    HCloud::PlacementGroup.all.each(&:delete)
    HCloud::Firewall.all.each(&:delete)
    HCloud::SSHKey.all.each(&:delete)
    HCloud::Volume.all.each(&:delete)

    # Unset client
    HCloud::Client.connection = @client

    # Disable real HTTP connections
    WebMock.disable_net_connect!
  end
end
