# frozen_string_literal: true

require "test_helper"
require "fileutils"

class CircuitCommandTest < Minitest::Test
  def setup
    @test_dir = File.join(Dir.tmpdir, "hyraft_test_#{Time.now.to_i}")
    FileUtils.mkdir_p(@test_dir)
  end

  def teardown
    FileUtils.rm_rf(@test_dir) if File.directory?(@test_dir)
  end

  def test_circuit_command_creates_file
    Hyraft::Rule::CircuitCommand.start(["UsersCircuit", @test_dir])
    
    expected_file = File.join(@test_dir, "engine/circuit/users_circuit.rb")
    assert File.exist?(expected_file), "Circuit file should be created"
    
    content = File.read(expected_file)
    assert_includes content, "class UsersCircuit < Engine::Circuit"
  end

  def test_circuit_command_with_complex_names
    Hyraft::Rule::CircuitCommand.start(["UserManagementCircuit", @test_dir])
    
    expected_file = File.join(@test_dir, "engine/circuit/user_management_circuit.rb")
    assert File.exist?(expected_file), "Circuit file should be created"
    
    content = File.read(expected_file)
    assert_includes content, "class UserManagementCircuit < Engine::Circuit"
  end
end