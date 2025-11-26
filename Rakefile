# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

task default: :test

namespace :test do
  desc "Run all engine tests"
  task :engine do
    sh "ruby -Ilib:test test/hyraft/test_rules/engine/source_test_rule.rb"
    sh "ruby -Ilib:test test/hyraft/test_rules/engine/circuit_test_rule.rb"
    sh "ruby -Ilib:test test/hyraft/test_rules/engine/port_test_rule.rb"
  end

  desc "Run only source tests"
  task :source do
    sh "ruby -Ilib:test test/hyraft/test_rules/engine/source_test_rule.rb"
  end

  desc "Run only circuit tests"
  task :circuit do
    sh "ruby -Ilib:test test/hyraft/test_rules/engine/circuit_test_rule.rb"
  end

  desc "Run only port tests"
  task :port do
    sh "ruby -Ilib:test test/hyraft/test_rules/engine/port_test_rule.rb"
  end

  desc "Run version test only"
  task :version do
    sh "ruby -Ilib:test test/hyraft/test_rule.rb --name=test_that_it_has_a_version_number"
  end
end