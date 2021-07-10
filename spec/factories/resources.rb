# frozen_string_literal: true

require "base64"

FactoryBot.define do
  factory :ssh_key do
    id { FFaker::Guid.guid }
    name { FFaker::Lorem.word }
    public_key { "ssh-rsa #{Base64.encode64(FFaker::Lorem.sentence)}" }
    fingerprint { FFaker::HEX.sample(32).each_cons(2).map(&:join).join(":") }
    labels { { production: true } }
  end
end
