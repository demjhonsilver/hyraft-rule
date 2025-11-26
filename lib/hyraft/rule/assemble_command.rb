# frozen_string_literal: true

require 'fileutils'

module Hyraft
  module Rule
    class AssembleCommand
      def self.start(args)
        new(args).execute
      end

      def initialize(args)
        @resource_input = args[0]  # Can be "users" or "admin-app/users"
        @target_dir = args[1] || "."
        parse_resource_input
      end

      def execute
        return show_manifest unless @resource_name

        puts "\e[35m🔧 Hyraft Assembly: Assembling '#{@resource_name}' resource\e[0m"
        puts "\e[36mApp Folder: #{@app_folder}\e[0m" if @app_folder != "web-app"
        
        assemble_engine_layer  
        assemble_adapter_layer
        
        puts "\e[32m✅ Assembly Complete: '#{@resource_name}' resource assembled\e[0m"
        puts "\e[36mNext steps:\e[0m"
        puts "  ⚡ Implement business logic in circuits" 
        puts "  🌐 Connect web adapters to router"
        puts "  📊 Create database table manually"
      end

      private

      def parse_resource_input
        return unless @resource_input

        if @resource_input.include?('/')
          @app_folder, @resource_name = @resource_input.split('/', 2)
        else
          @app_folder = "web-app"
          @resource_name = @resource_input
        end
      end

      def assemble_engine_layer
        puts "\e[34m⚡ Assembling Engine Layer...\e[0m"
        
        # Check if engine files already exist
        singular_name = @resource_name.end_with?('s') ? @resource_name[0..-2].capitalize : @resource_name.capitalize
        source_path = File.join(@target_dir, "engine/source/#{singular_name.downcase}.rb")
        circuit_path = File.join(@target_dir, "engine/circuit/#{@resource_name.downcase}_circuit.rb")
        port_path = File.join(@target_dir, "engine/port/#{@resource_name.downcase}_gateway_port.rb")
        
        if File.exist?(source_path) || File.exist?(circuit_path) || File.exist?(port_path)
          puts "   ⚠️  Engine files already exist - skipping engine layer"
          return
        end
        
        # Pass singular name for source, plural for others
        SourceCommand.start([singular_name, @target_dir])
        CircuitCommand.start(["#{@resource_name.capitalize}Circuit", @target_dir])
        PortCommand.start(["#{@resource_name.capitalize}GatewayPort", @target_dir])
      end

      def assemble_adapter_layer
        puts "\e[34m🔌 Assembling Adapter Layer...\e[0m"
        # Pass folder/resource format to web adapter command
        AdapterRequest::WebAdapterCommand.start(["#{@app_folder}/#{@resource_name}", @target_dir])
        AdapterExhaust::DataGatewayCommand.start([@resource_name, @target_dir])

        # Generate templates as well
        puts "\e[34m📝 Generating Templates...\e[0m"
        TemplateCommand.start(["#{@app_folder}/#{@resource_name}", @target_dir])

      end

      def show_manifest
        puts "Hyraft Assembly Manifest"
        puts "Usage: hyraft-rule assemble [folder/]<resource_name> [target_dir]"
        puts ""
        puts "Examples:"
        puts "  hyraft-rule assemble articles                    # Default: web-app/articles"
        puts "  hyraft-rule assemble users                       # Default: web-app/users"
        puts "  hyraft-rule assemble admin-app/users             # Creates: admin-app/users"
        puts "  hyraft-rule assemble api/products                # Creates: api/products"
        puts "  hyraft-rule assemble mobile/categories           # Creates: mobile/categories"
        puts ""
        puts "Assembly Components:"
        puts "  ⚡ Engine Layer → Sources + Circuits + Ports"
        puts "  🔌 Adapter Layer → Web Adapters + Data Gateways"
        puts ""
        puts "Note: Database migrations must be created separately"
      end
    end
  end
end