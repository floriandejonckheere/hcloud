# frozen_string_literal: true

require_relative "lib/hcloud/version"

Gem::Specification.new do |spec|
  spec.name          = "hcloud"
  spec.version       = HCloud::VERSION
  spec.authors       = ["Florian Dejonckheere"]
  spec.email         = ["florian@floriandejonckheere.be"]

  spec.summary       = "Ruby library for Hetzner Cloud API"
  spec.description   = "Native Ruby integration with the Hetzner Cloud API"
  spec.homepage      = "https://github.com/floriandejonckheere/hcloud"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7")

  spec.metadata["source_code_uri"] = "https://github.com/floriandejonckheere/hcloud.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["README.md", "LICENSE.md", "CHANGELOG.md", "Gemfile", "lib/**/*.rb", "config/*.rb"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "http"
  spec.add_runtime_dependency "zeitwerk"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "debase"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "ffaker"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "webmock"
end
