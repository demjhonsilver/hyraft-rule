# frozen_string_literal: true

require_relative "rule/version"

module Hyraft
  module Rule
    class Error < StandardError; end
    
    # Auto-require all command files
    require_relative "rule/command"

    # Engine rules:
    require_relative "rule/engine/source_command"
    require_relative "rule/engine/circuit_command"
    require_relative "rule/engine/port_command"
    require_relative "rule/adapter_request/web_adapter_command"
    require_relative "rule/adapter_request/remove_adapter_command"
    require_relative "rule/adapter_exhaust/data_gateway_command"

    # Assemble rules:
    require_relative "rule/assemble_command"
    require_relative "rule/disassemble_command" 


    # Template rules:
    require_relative "rule/template_command" 


    
    def self.find_app_root
      dir = Dir.pwd
      while dir != '/'
        boot_path = File.join(dir, 'boot.rb')
        return dir if File.exist?(boot_path)
        dir = File.dirname(dir)
      end
      nil
    end
  end
end