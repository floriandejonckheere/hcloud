# frozen_string_literal: true

require_relative "lib/hcloud/version"

Gem::Specification.new do |spec|
  spec.name          = "hetznercloud"
  spec.version       = HCloud::VERSION
  spec.authors       = ["Florian Dejonckheere"]
  spec.email         = ["florian@floriandejonckheere.be"]

  spec.summary       = "Ruby library wrapping the Hetzner Cloud API"
  spec.description   = "Native Ruby integration with the Hetzner Cloud API"
  spec.homepage      = "https://github.com/floriandejonckheere/hcloud"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2")

  spec.metadata["source_code_uri"] = "https://github.com/floriandejonckheere/hcloud.git"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["README.md", "LICENSE.md", "CHANGELOG.md", "Gemfile", "lib/**/*.rb", "config/*.rb"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel"
  spec.add_dependency "activesupport"
  spec.add_dependency "http"
  spec.add_dependency "openssl"
  spec.add_dependency "zeitwerk"
end
