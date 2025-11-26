# lib/hyraft/rule/adapter_request/web_adapter_command.rb

require 'fileutils'

module Hyraft
  module Rule
    module AdapterRequest
      class WebAdapterCommand
        def self.start(args)
          input = args[0]
          return show_usage unless input

          if input.include?('/')
            folder_name, adapter_name = input.split('/', 2)
          else
            folder_name = "web-app"
            adapter_name = input
          end

          target_dir = args[1] || "."
          adapters_dir = File.join(target_dir, "adapter-intake", folder_name, "request")
          full_path = File.join(adapters_dir, "#{adapter_name.downcase}_web_adapter.rb")

          FileUtils.mkdir_p(adapters_dir)
          File.write(full_path, web_adapter_template(adapter_name, folder_name))

          puts "\e[94m✓ Created web adapter: #{full_path}\e[0m"
          puts "\e[38;5;214mApp folder name: #{folder_name}, Adapter: #{adapter_name}\e[0m"
        end

        private

        def self.show_usage
          puts "Usage: hyraft-rule web-adapter [folder_name/]<AdapterName> [target_dir]"
          puts ""
          puts "Examples:"
          puts "  hyraft-rule web-adapter Articles"
          puts "  hyraft-rule web-adapter admin/Users"
          puts "  hyraft-rule web-adapter api-app/Products"
          puts "  hyraft-rule web-adapter mobile/Categories"
          puts ""
          puts "Default folder: web-app"
        end

        def self.web_adapter_template(adapter_name, folder_name = "web-app")
          singular_name = adapter_name.downcase.chomp('s')
          adapter_class_name = adapter_name.split('_').map(&:capitalize).join  # "articles" → "Articles"
          plural_name = singular_name + 's'
          circuit_name = "#{adapter_class_name}Circuit"
          gateway_name = "Sequel#{adapter_class_name}Gateway"

          <<~RUBY
require_root 'engine/circuit/#{plural_name}_circuit'
require_root 'adapter-exhaust/data-gateway/sequel_#{plural_name}_gateway'

class #{adapter_class_name}WebAdapter
  def initialize
    gateway = #{gateway_name}.new
    @#{plural_name} = #{circuit_name}.new(gateway)
  end

  # GET /#{plural_name}
  def index(request)
    #{plural_name} = @#{plural_name}.list || []
    
    {
      status: 200,
      locals: { 
        #{plural_name}: #{plural_name}
      },
      display: 'pages/#{plural_name}/index.hyr'
    }
  end

  # GET /#{plural_name}/:id
  def show(request)
    id = request.params['route_params'].first
    #{singular_name} = @#{plural_name}.find(id)

    if #{singular_name}
      {
        status: 200,
        locals: { 
          #{singular_name}: #{singular_name}
        },
        display: 'pages/#{plural_name}/show.hyr'
      }
    else
      not_found_response(request)
    end
  end

  # GET /#{plural_name}/new - Show create form
  def new(request)
    {
      status: 200,
      locals: {},
      display: 'pages/#{plural_name}/new.hyr'
    }
  end

  # POST /#{plural_name} - Create #{singular_name}
  def create(request)
    data = request.params['data'] || {}
    
    # TODO: Add validation for required fields
    # Example:
    # if data['title'] && data['content']
    #   article = @articles.create(
    #     title: data['title'],
    #     content: data['content']
    #   )
    #   
    #   {
    #     status: 303,
    #     headers: { 'Location' => "/articles" },
    #     locals: {}
    #   }
    # else
    #   {
    #     status: 422,
    #     locals: { 
    #       error: "Title and content are required"
    #     },
    #     display: 'pages/articles/new.hyr'
    #   }
    # end
    
  end

  # GET /#{plural_name}/:id/edit - Show edit form
  def edit(request)
    id = request.params['route_params'].first
    #{singular_name} = @#{plural_name}.find(id)
    
    if #{singular_name}
      {
        status: 200,
        locals: { 
          #{singular_name}: #{singular_name}
        },
        display: 'pages/#{plural_name}/edit.hyr'
      }
    else
      not_found_response(request)
    end
  end

  # PUT /#{plural_name}/:id - Update #{singular_name}
  def update(request)
    id = request.params['route_params'].first
    data = request.params['data'] || {}
    
    # TODO: Implement update logic
    # Example:
    # updated_#{singular_name} = @#{plural_name}.update(
    #   id: id,
    #   title: data['title'],
    #   content: data['content']
    # )
    
    if updated_#{singular_name}
      {
        status: 303,
        headers: { 'Location' => "/#{plural_name}" },
        locals: {}
      }
    else
      {
        status: 422,
        locals: { 
          #{singular_name}: @#{plural_name}.find(id),
          error: "Failed to update #{singular_name}" 
        },
        display: 'pages/#{plural_name}/edit.hyr'
      }
    end
  end

  # DELETE /#{plural_name}/:id - Delete #{singular_name}
  def delete(request)
    id = request.params['route_params'].first
    @#{plural_name}.delete(id)
    
    {
      status: 303,
      headers: { 'Location' => "/#{plural_name}" },
      locals: {}
    }
  end

  private

  def not_found_response(request)
    {
      status: 404,
      locals: { 
        error: "#{singular_name.capitalize} not found",
        back_url: '/#{plural_name}',  
        back_text: 'Back to #{adapter_name}'  
      },
      display: 'pages/#{plural_name}/404.hyr'
    }
  end
end
          RUBY
        end
      end
    end
  end
end