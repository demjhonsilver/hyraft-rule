# frozen_string_literal: true

require 'fileutils'

module Hyraft
  module Rule
    class RemoveAdapterCommand
      def self.start(args)
        new(args).execute
      end

      def initialize(args)
        @adapter_input = args[0]  # "admin-app/users" or "api-app/products"
        @target_dir = args[1] || "."
        parse_adapter_input
      end

      def execute
        return show_manifest unless @adapter_name

        puts "\e[33m🗑️  Removing adapter: '#{@app_folder}/#{@adapter_name}'\e[0m"
        
        remove_adapter_only
        
        puts "\e[32m✅ Adapter removed: '#{@app_folder}/#{@adapter_name}'\e[0m"
        puts "\e[36mNote: Engine layer and other adapters preserved\e[0m"
      end

      private

      def parse_adapter_input
        return unless @adapter_input

        if @adapter_input.include?('/')
          @app_folder, @adapter_name = @adapter_input.split('/', 2)
        else
          puts "❌ Error: Please specify app folder (e.g., admin-app/users)"
          exit 1
        end
      end

      def remove_adapter_only
        # Only remove the specific web adapter
        adapter_path = "adapter-intake/#{@app_folder}/request/#{@adapter_name.downcase}_web_adapter.rb"
        delete_file(adapter_path)
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
        puts "Hyraft Remove Adapter"
        puts "Usage: hyraft-rule remove-adapter <folder>/<adapter_name> [target_dir]"
        puts ""
        puts "Examples:"
        puts "  hyraft-rule remove-adapter admin-app/users"
        puts "  hyraft-rule remove-adapter api-app/products"
        puts "  hyraft-rule remove-adapter mobile-app/categories"
        puts ""
        puts "This command only removes the web adapter, preserving:"
        puts "  • Engine layer (sources, circuits, ports)"
        puts "  • Data gateway"
        puts "  • Other app adapters"
        puts ""
        puts "Use 'hyraft-rule disassemble' to remove entire resource"
      end
    end
  end
end