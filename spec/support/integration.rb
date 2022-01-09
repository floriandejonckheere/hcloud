# frozen_string_literal: true

RSpec.configure do |config|
  logger = Logger.new($stdout)
  logger.level = ENV.fetch("LOG_LEVEL", "warn")

  config.around(:context, integration: true) do |example|
    cassette_name = example.metadata[:example_group][:full_description].demodulize.underscore

    VCR.use_cassette(cassette_name, record: :new_episodes) { example.run }
  end

  config.before(:context, integration: true) do
    @client = HCloud::Client.connection

    # Set client
    HCloud::Client.connection = HCloud::Client.new(
      access_token: ENV.fetch("HCLOUD_TOKEN"),
      logger: logger,
    )

    # Enable real HTTP connections
    WebMock.allow_net_connect!

    # Clean up cloud resources
    HCloud::PlacementGroup.all.each(&:delete)
    HCloud::Server.all.each(&:delete)
    HCloud::SSHKey.all.each(&:delete)
  end

  config.after(:context, integration: true) do
    # Clean up cloud resources
    HCloud::PlacementGroup.all.each(&:delete)
    HCloud::Server.all.each(&:delete)
    HCloud::SSHKey.all.each(&:delete)

    # Unset client
    HCloud::Client.connection = @client

    # Disable real HTTP connections
    WebMock.disable_net_connect!
  end
end
