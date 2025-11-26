# frozen_string_literal: true

module Hyraft
  module Rule
    class Command
      def self.start(argv)
        new(argv).execute
      end

      def initialize(argv)
        @argv = argv
        @command = argv[0]
        @args = argv[1..-1]
      end

      def execute
        case @command
        when "migrate"
          MigrationCommand.start(@args)
        when "source"
          SourceCommand.start(@args)
        when "circuit"
          CircuitCommand.start(@args)
        when "port"
          PortCommand.start(@args)
        when "web-adapter"
          AdapterRequest::WebAdapterCommand.start(@args)
        when "data-gateway"
          AdapterExhaust::DataGatewayCommand.start(@args)
        when "assemble"
          AssembleCommand.start(@args)
        when "disassemble"  
          DisassembleCommand.start(@args)
        when "template" 
          TemplateCommand.start(@args)
        when "remove-adapter", "rm-adapter"
          require 'hyraft/rule/adapter_request/remove_adapter_command'
          RemoveAdapterCommand.start(@args)
        when "version", "-v", "--version"
          puts "Hyraft Rule version #{VERSION}"
        when "help", "-h", "h", "--help", nil
          show_help
        else
          puts "Unknown command: #{@command}"
          show_help
        end
      end

      private

      def show_help
        puts "Hyraft Rule - Command System for Hyraft Applications"
        puts ""
        puts "Commands:"
        puts "  source           Generate source files"
        puts "  circuit          Generate circuit files"
        puts "  port             Generate port files"
        puts "  web-adapter      Generate web adapter files"
        puts "  data-gateway     Generate data gateway files"
        puts "  template         Generate .hyr template files"
        puts "  assemble         Assemble Engine + Adapters for a resource"
        puts "  disassemble      Remove assembled Engine + Adapters for a resource"
        puts "  remove-adapter   Remove specific adapter only (preserves engine)"
        puts "  version          Show version information"
        puts "  help             Show this help message"
        puts ""
        puts "Run 'hyr-rule <command>"
        puts "Run 'hyraft-rule <command>"
        puts ""
        puts ""
        puts "Database Commands:"
        puts "Run 'hyr-rule-db <command>"
        puts "Run 'hyraft-rule-db <command>"
        puts ""
        puts ""
      end
    end
  end
end