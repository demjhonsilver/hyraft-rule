# lib/hyraft/rule/adapter_exhaust/data_gateway_command.rb
# frozen_string_literal: true

require 'fileutils'

module Hyraft
  module Rule
    module AdapterExhaust
      class DataGatewayCommand
        def self.start(args)
          new(args).execute
        end

        def initialize(args)
          @gateway_name = args[0]
          @table_name = extract_table_name(@gateway_name)
          @target_dir = args[1] || "."
        end

        def execute
          return show_usage unless @gateway_name

          filename = "sequel_#{@table_name}_gateway.rb"
          gateway_dir = File.join(@target_dir, "adapter-exhaust/data-gateway")
          full_path = File.join(gateway_dir, filename)

          FileUtils.mkdir_p(gateway_dir)
          File.write(full_path, gateway_template)

          puts "✓ Created gateway: #{full_path}"
          puts "Table name: #{@table_name}"
          puts "Port Adapter: #{port_class_name}"
          puts "Resource: #{source_class_name}"
        end

        private

        def extract_table_name(gateway_name)
          gateway_name.sub(/_(gateway)?$/, '')
        end

        def port_class_name
          "#{@table_name.capitalize}GatewayPort"
        end

        def gateway_class_name
          "Sequel#{@table_name.capitalize}Gateway"
        end

        def source_class_name
          @table_name.end_with?('s') ? @table_name[0..-2].capitalize : @table_name.capitalize
        end

        def source_variable_name
          @table_name.end_with?('s') ? @table_name[0..-2] : @table_name
        end

        def show_usage
          puts "Usage: hyraft-rule data-gateway <gateway_name> [target_dir]"
          puts ""
          puts "Examples:"
          puts "  hyraft-rule data-gateway articles"
          puts "  hyraft-rule data-gateway users"
          puts "  hyraft-rule data-gateway products"
          puts ""
          puts "This creates: adapter-exhaust/data-gateway/sequel_<name>_gateway.rb"
        end

        def gateway_template
          port_name = port_class_name
          gateway_name = gateway_class_name
          source_name = source_class_name
          source_var = source_variable_name
          
          <<~RUBY
            require_root 'engine/port/#{@table_name}_gateway_port'
            require_root 'engine/source/#{source_var}'
            require_root 'infra/database/sequel_connection'

            class #{gateway_name} < #{port_name}
              def initialize
                @db = SequelConnection.db
                @#{@table_name} = @db[:#{@table_name}]
              end

              def save(#{source_var})
                if #{source_var}.id && find(#{source_var}.id)
                  @#{@table_name}.where(id: #{source_var}.id.to_i).update(
                    # Add update fields here
                    updated_at: Time.now
                  )
                else
                  id = @#{@table_name}.insert(
                    # Add insert fields here
                    created_at: Time.now,
                    updated_at: Time.now
                  )
                  #{source_var}.id = id.to_s
                end
                #{source_var}
              end

              def all
                @#{@table_name}.order(Sequel.desc(:created_at)).all.map { |row| map_row_to_#{source_var}(row) }
              end

              def find(id)
                row = @#{@table_name}.where(id: id.to_i).first
                row && map_row_to_#{source_var}(row)
              end

              def delete(id)
                @#{@table_name}.where(id: id.to_i).delete
              end

              private

              def map_row_to_#{source_var}(row)
                #{source_name}.new(
                  id: row[:id].to_s,
                  # Add entity attributes here
                  created_at: row[:created_at],
                  updated_at: row[:updated_at]
                )
              end
            end
          RUBY
        end
      end
    end
  end
end