# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "hyraft/rule"

require "minitest/autorun"

=begin

rake test (all)



# Run specific test groups
rake test:engine
rake test:source
rake test:circuit
rake test:port
rake test:version

# Run individual test files
ruby -Ilib:test test/hyraft/test_rules/engine/source_test_rule.rb
ruby -Ilib:test test/hyraft/test_rules/engine/circuit_test_rule.rb
ruby -Ilib:test test/hyraft/test_rules/engine/port_test_rule.rb

# Run with Minitest filters
rake test TESTOPTS="--name=test_source_command_creates_file"

=end


