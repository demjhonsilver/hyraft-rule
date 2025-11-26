# frozen_string_literal: true

require "test_helper"
require "fileutils"

class SourceCommandTest < Minitest::Test
  def setup
    @test_dir = File.join(Dir.tmpdir, "hyraft_test_#{Time.now.to_i}")
    FileUtils.mkdir_p(@test_dir)
  end

  def teardown
    FileUtils.rm_rf(@test_dir) if File.directory?(@test_dir)
  end

  def test_source_command_creates_file
    Hyraft::Rule::SourceCommand.start(["User", @test_dir])
    
    expected_file = File.join(@test_dir, "engine/source/user.rb")
    assert File.exist?(expected_file), "Source file should be created"
    
    content = File.read(expected_file)
    assert_includes content, "class User < Engine::Source"
  end

  def test_source_command_with_different_names
    Hyraft::Rule::SourceCommand.start(["Product", @test_dir])
    
    expected_file = File.join(@test_dir, "engine/source/product.rb")
    assert File.exist?(expected_file), "Source file should be created"
    
    content = File.read(expected_file)
    assert_includes content, "class Product < Engine::Source"
  end
end