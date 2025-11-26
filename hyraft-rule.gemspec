# frozen_string_literal: true

require_relative "lib/hyraft/rule/version"

Gem::Specification.new do |spec|
  spec.name = "hyraft-rule"
  spec.version = Hyraft::Rule::VERSION
  spec.authors = ["Demjhon Silver"]


  spec.summary = "Hyraft Rule - Command system for Hyraft applications"
  spec.description = "A standalone command system with migrations for Hyraft applications"
  spec.homepage = "https://github.com/demjhonsilver/hyraft-rule"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Manual file listing without git dependency
# In hyraft-rule.gemspec - update the files section
  spec.files = [
    "exe/hyraft-rule",
    "exe/hyraft-rule-db",
    "exe/hyr-rule",
    "exe/hyr-rule-db",
    "lib/hyraft/rule.rb",
    "lib/hyraft/rule/version.rb",
    "lib/hyraft/rule/command.rb",
    "lib/hyraft/rule/engine/source_command.rb",
    "lib/hyraft/rule/engine/circuit_command.rb",
    "lib/hyraft/rule/engine/port_command.rb",
    "lib/hyraft/rule/adapter_request/web_adapter_command.rb",
    "lib/hyraft/rule/adapter_request/remove_adapter_command.rb",
    "lib/hyraft/rule/adapter_exhaust/data_gateway_command.rb", 
    "lib/hyraft/rule/assemble_command.rb", 
    "lib/hyraft/rule/disassemble_command.rb", 
     "lib/hyraft/rule/template_command.rb", 
    "LICENSE.txt",
    "README.md",
    "CHANGELOG.md",
    "hyraft-rule.gemspec"
  ]
  
  spec.bindir = "exe"
  spec.executables = ["hyraft-rule", "hyraft-rule-db", "hyr-rule", "hyr-rule-db"]
  spec.require_paths = ["lib"]


  
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end