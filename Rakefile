# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

Dir.glob("lib/tasks/**/*.rake").each { |r| load r }

task default: :spec
