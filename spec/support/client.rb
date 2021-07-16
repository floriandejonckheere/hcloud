# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) { HCloud::Client.connection = HCloud::Client.new(access_token: "dummy_token") }
end
