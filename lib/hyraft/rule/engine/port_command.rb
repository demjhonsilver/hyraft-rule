# frozen_string_literal: true

require 'fileutils'

module Hyraft
  module Rule
    class PortCommand
      def self.start(args)
        port_name = args[0]
        return show_usage unless port_name

        target_dir = args[1] || "."
        port_dir = File.join(target_dir, "engine/port")
        # Convert CamelCase to snake_case with underscore
        filename = port_name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase + ".rb"
        full_path = File.join(port_dir, filename)

        FileUtils.mkdir_p(port_dir)
        File.write(full_path, port_template(port_name))

        puts "✓ Created port: #{full_path}"
      end

      private

      def self.show_usage
        puts "Usage: hyraft-rule port <PortName> [target_dir]"
        puts ""
        puts "Examples:"
        puts "  hyraft-rule port ArticlesGatewayPort"
        puts "  hyraft-rule port UsersGatewayPort"
        puts "  hyraft-rule port ProductsGatewayPort"
        puts ""
        puts "This creates interface ports in engine/port/"
      end

      def self.port_template(port_name)
        <<~RUBY
          class #{port_name} < Engine::Port
            def save(entity)
              raise NotImplementedError
            end
            
            def all
              raise NotImplementedError
            end
            
            def find(id)
              raise NotImplementedError
            end
            
            def delete(id)
              raise NotImplementedError
            end
          end
        RUBY
      end
    end
  end
end