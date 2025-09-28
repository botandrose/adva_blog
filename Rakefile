#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # rspec not available yet
end

begin
  require 'appraisal'
  # Define `rake appraisal:install` and `rake appraisal:spec`
rescue LoadError
  # appraisal not available yet
end

task default: :spec
