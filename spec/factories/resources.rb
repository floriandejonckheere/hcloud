# frozen_string_literal: true

require "base64"

FactoryBot.define do
  factory :placement_group, class: "HCloud::PlacementGroup" do
    id { FFaker::Random.rand(111_111_111..999_999_999) }
    name { FFaker::Lorem.word }
    type { "spread" }
    labels { { production: true } }
  end

  factory :ssh_key, class: "HCloud::SSHKey" do
    id { FFaker::Random.rand(111_111_111..999_999_999) }
    name { FFaker::Lorem.word }
    public_key { "ssh-rsa #{Base64.encode64(FFaker::Lorem.sentence)}" }
    fingerprint { FFaker::HEX.sample(32).each_cons(2).map(&:join).join(":") }
    labels { { production: true } }
  end
end
