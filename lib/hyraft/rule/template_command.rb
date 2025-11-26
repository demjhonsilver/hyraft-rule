# frozen_string_literal: true

require 'fileutils'

module Hyraft
  module Rule
    class TemplateCommand
      def self.start(args)
        new(args).execute
      end

      def initialize(args)
        @resource_input = args[0]  # "users" or "admin-app/users"
        @target_dir = args[1] || "."
        parse_resource_input
      end

      def execute
        return show_usage unless @resource_name

        puts "\e[36m📝 Generating .hyr templates for '#{@resource_name}'\e[0m"
        generate_templates
        puts "\e[32m✅ Templates generated in #{@app_folder}/display/pages/#{@resource_name}/\e[0m"
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

      def generate_templates
        templates_dir = File.join(@target_dir, "adapter-intake", @app_folder, "display", "pages", @resource_name)
        FileUtils.mkdir_p(templates_dir)

        generate_template_file(dir: templates_dir, filename: "index.hyr", template_name: "index")
        generate_template_file(dir: templates_dir, filename: "show.hyr", template_name: "show")
        generate_template_file(dir: templates_dir, filename: "new.hyr", template_name: "new")
        generate_template_file(dir: templates_dir, filename: "edit.hyr", template_name: "edit")
      end

      def generate_template_file(dir:, filename:, template_name:)
        singular = @resource_name.chomp('s')
        component_name = "#{singular}_#{template_name}"
        component_name_displayer = "#{singular}-#{template_name}"
        
        content = <<HTML
<metadata html>
<!-- #{component_name} meta-tags component -->
</metadata>

<displayer html>
<div class="#{component_name_displayer}">
<#{component_name_displayer} context="World" />
</div>
</displayer>

<transmuter rb>

def display_#{component_name}(context:)
"<div class='component'>Hello \#{context} from #{component_name}!</div>"
end

</transmuter>

<manifestor js>

// #{component_name} JavaScript code

</manifestor>

<style src="/styles/css/main.css" />
HTML

        File.write(File.join(dir, filename), content)
        puts "   ✓ Created: #{filename}"
      end

      def show_usage
        puts "Usage: hyraft-rule template [folder/]<resource_name> [target_dir]"
        puts ""
        puts "Examples:"
        puts "  hyraft-rule template articles"
        puts "  hyraft-rule template admin-app/users"
        puts "  hyraft-rule template api/products"
        puts ""
        puts "Generates 4 template files in adapter-intake/<folder>/display/pages/<resource>/:"
        puts "  • index.hyr"
        puts "  • show.hyr" 
        puts "  • new.hyr"
        puts "  • edit.hyr"
      end
    end
  end
end