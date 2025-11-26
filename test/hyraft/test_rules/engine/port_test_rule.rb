# frozen_string_literal: true

require "test_helper"
require "fileutils"

class PortCommandTest < Minitest::Test
  def setup
    @test_dir = File.join(Dir.tmpdir, "hyraft_test_#{Time.now.to_i}")
    FileUtils.mkdir_p(@test_dir)
  end

  def teardown
    FileUtils.rm_rf(@test_dir) if File.directory?(@test_dir)
  end

  def test_port_command_creates_file
    Hyraft::Rule::PortCommand.start(["UsersGatewayPort", @test_dir])
    
    expected_file = File.join(@test_dir, "engine/port/users_gateway_port.rb")
    assert File.exist?(expected_file), "Port file should be created"
    
    content = File.read(expected_file)
    assert_includes content, "class UsersGatewayPort < Engine::Port"
  end

  def test_port_command_name_conversion
    Hyraft::Rule::PortCommand.start(["ArticleGatewayPort", @test_dir])
    
    expected_file = File.join(@test_dir, "engine/port/article_gateway_port.rb")
    assert File.exist?(expected_file), "Port file should be created"
    
    content = File.read(expected_file)
    assert_includes content, "class ArticleGatewayPort < Engine::Port"
  end
end