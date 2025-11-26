# frozen_string_literal: true

require 'fileutils'

module Hyraft
  module Rule
    class CircuitCommand
      def self.start(args)
        circuit_name = args[0]
        return show_usage unless circuit_name

        target_dir = args[1] || "."
        circuit_dir = File.join(target_dir, "engine/circuit")
        filename = circuit_name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase + ".rb"
        full_path = File.join(circuit_dir, filename)

        FileUtils.mkdir_p(circuit_dir)
        File.write(full_path, circuit_template(circuit_name))

        puts "✓ Created circuit: #{full_path}"
      end

      private

      def self.show_usage
        puts "Usage: hyraft-rule circuit <CircuitName> [target_dir]"
        puts ""
        puts "Examples:"
        puts "  hyraft-rule circuit ArticlesCircuit"
        puts "  hyraft-rule circuit UsersCircuit"
        puts "  hyraft-rule circuit ProductsCircuit"
        puts ""
        puts "This creates business processes in engine/circuit/"
      end

      def self.circuit_template(circuit_name)
        <<~RUBY
          class #{circuit_name} < Engine::Circuit
            def initialize(gateway)
              @gateway = gateway
            end

            def create(params)
              # Implement create logic
            end

            def find(id)
              # Implement find logic
            end

            def list
              # Implement list logic
            end

            def update(params)
              # Implement update logic
            end

            def delete(id)
              # Implement delete logic
            end

            def execute(input = {})
              operation = input[:operation]
              params = input[:params] || {}
              
              case operation
              when :create then create(params)
              when :list then list
              when :find then find(params[:id])
              when :update then update(params)
              when :delete then delete(params[:id])
              else
                raise "Unknown operation: \#{operation}"
              end
            end
          end
        RUBY
      end
    end
  end
end