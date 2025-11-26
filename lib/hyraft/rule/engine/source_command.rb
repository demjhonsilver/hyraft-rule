# lib/hyraft/rule/engine/source_command.rb
# frozen_string_literal: true

require 'fileutils'

module Hyraft
  module Rule
    class SourceCommand
      def self.start(args)
        new(args).execute
      end

      def initialize(args)
        @source_name = args[0]
        @target_dir = args[1] || "."
      end

      def execute
        return show_usage unless @source_name

        # Convert to singular for filename
        singular_name = @source_name.end_with?('s') ? @source_name[0..-2] : @source_name
        
        filename = "#{singular_name.downcase}.rb" 
        source_dir = File.join(@target_dir, "engine/source")
        full_path = File.join(source_dir, filename)

        FileUtils.mkdir_p(source_dir)
        File.write(full_path, source_template(@source_name))

        puts "✓ Created source: #{full_path}"
      end

      private

      def show_usage
        puts "Usage: hyraft-rule source <SourceName> [target_dir]"
        puts ""
        puts "Examples:"
        puts "  hyraft-rule source Article"
        puts "  hyraft-rule source User" 
        puts "  hyraft-rule source Product"
        puts ""
        puts "This creates domain sources in engine/source/"
      end

      def source_template(source_name)
        <<~RUBY
          class #{source_name} < Engine::Source
            attr_accessor :created_at, :updated_at

            def initialize(id: nil, created_at: nil, updated_at: nil)
              super(id: id)
              
              @created_at = created_at || Time.now
              @updated_at = updated_at
            end

            def to_hash
              super.merge({
                created_at: @created_at,
                updated_at: @updated_at
              })
            end
          end
        RUBY
      end
    end
  end
end