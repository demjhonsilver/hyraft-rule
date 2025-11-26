# frozen_string_literal: true

require "test_helper"

# Require all test files
Dir[File.join(__dir__, "test_rules", "**", "*_test_rule.rb")].each { |file| require file }

class Hyraft::TestRule < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Hyraft::Rule::VERSION
  end
end