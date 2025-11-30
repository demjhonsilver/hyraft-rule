require 'fileutils'

module Hyraft
  module Rule
    class DisassembleCommand
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

        puts "\e[31m🗑️  COMPLETE Disassembly: Removing ALL '#{@resource_name}' resources\e[0m"
        puts "\e[33m⚠️  WARNING: This will remove engine layer, ALL adapters, and ALL templates!\e[0m"
        puts ""
        puts "This will delete:"
        puts "  • Engine layer (sources, circuits, ports)"
        puts "  • ALL web adapters (across all app folders)" 
        puts "  • ALL templates (across all app folders)"
        puts "  • Data gateway"
        puts ""
        print "\e[31mAre you sure you want to continue? (yes/NO): \e[0m"
        
        confirmation = $stdin.gets.chomp.downcase
        unless confirmation == 'yes'
          puts "\e[32mDisassembly cancelled\e[0m"
          return
        end
        
        disassemble_engine_layer  
        disassemble_all_adapters
        disassemble_all_templates
        disassemble_gateway
        
        puts "\e[32m✅ Complete Disassembly: ALL '#{@resource_name}' resources removed\e[0m"
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

      def disassemble_engine_layer
        puts "\e[34m⚡ Removing Engine Layer...\e[0m"

        # Source is singular
        singular_resource = @resource_name.end_with?('s') ? @resource_name[0..-2] : @resource_name
        delete_file("engine/source/#{singular_resource.downcase}.rb")
        delete_file("engine/circuit/#{@resource_name.downcase}_circuit.rb")
        delete_file("engine/port/#{@resource_name.downcase}_gateway_port.rb")
      end

      def disassemble_all_adapters
        puts "\e[34m🔌 Removing ALL Adapters...\e[0m"
        
        # Find and remove all adapters for this resource across all app folders
        adapter_base_dir = File.join(@target_dir, "adapter-intake")
        if File.directory?(adapter_base_dir)
          Dir.glob(File.join(adapter_base_dir, "*", "request", "#{@resource_name.downcase}_web_adapter.rb")).each do |adapter_path|
            relative_path = adapter_path.gsub("#{@target_dir}/", "")
            delete_file(relative_path)
          end
        end
      end

      def disassemble_all_templates
        puts "\e[34m📝 Removing ALL Templates...\e[0m"
        
        # Find and remove all template directories for this resource across all app folders
        template_base_dir = File.join(@target_dir, "adapter-intake")
        if File.directory?(template_base_dir)
          Dir.glob(File.join(template_base_dir, "*", "display", "pages", @resource_name.downcase)).each do |template_dir|
            if File.directory?(template_dir)
              FileUtils.rm_rf(template_dir)
              relative_path = template_dir.gsub("#{@target_dir}/", "")
              puts "   ✓ Deleted template directory: #{relative_path}"
            end
          end
        end
      end

      def disassemble_gateway
        delete_file("adapter-exhaust/data-gateway/sequel_#{@resource_name.downcase}_gateway.rb")
      end

      def delete_file(relative_path)
        full_path = File.join(@target_dir, relative_path)
        if File.exist?(full_path)
          File.delete(full_path)
          puts "   ✓ Deleted: #{relative_path}"
        else
          puts "   ⚠️  Not found: #{relative_path}"
        end
      end

      def show_manifest
        puts "Hyraft Disassembly Manifest"
        puts "Usage: hyraft-rule disassemble [folder/]<resource_name> [target_dir]"
        puts ""
        puts "Examples:"
        puts "  hyraft-rule disassemble articles                    # Default: web-app/articles"
        puts "  hyraft-rule disassemble users                       # Default: web-app/users"
        puts "  hyraft-rule disassemble admin-app/users             # Deletes: admin-app/users"
        puts "  hyraft-rule disassemble api/products                # Deletes: api/products"
        puts "  hyraft-rule disassemble mobile/categories           # Deletes: mobile/categories"
        puts ""
        puts "⚠️  WARNING: This removes EVERYTHING for the resource:"
        puts "  • Engine layer (sources, circuits, ports)"
        puts "  • ALL web adapters (across all app folders)"
        puts "  • ALL templates (across all app folders)"
        puts "  • Data gateway"
        puts ""
        puts "Use 'hyraft-rule remove-adapter' to remove just one adapter"
        puts "Use 'hyraft-rule remove-template' to remove just templates (if you add this command)"
        puts ""
        puts "Disassembly Components:"
        puts "  ⚡ Engine Layer → Sources + Circuits + Ports"
        puts "  🔌 Adapter Layer → Web Adapters + Data Gateways"
        puts "  📝 Template Layer → .hyr template files"
        puts ""
        puts "Note: Database tables and migrations are not affected"
      end
    end
  end
end