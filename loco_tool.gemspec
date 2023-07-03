Gem::Specification.new do |spec|
    spec.name          = "loco_tool"
    spec.version       = "0.1.3"
    spec.authors       = ["Aleksei Cherepanov"]
    spec.email         = ["ftp27host@gmail.com"]
    spec.summary       = "A CLI tool for parsing and validating localization strings"
    spec.description   = "loco_tool is a command-line tool written in Ruby that helps parse, validate, and manipulate localization strings for iOS and Android projects."
    spec.homepage      = "https://github.com/ftp27/loco_tool"
    spec.license       = "MIT"
  
    spec.extra_rdoc_files = ["README.md", "LICENSE"]
    spec.files         = Dir["lib/**/*.rb"]
    spec.require_paths = ["lib"]
  
    spec.add_dependency "loco_strings", "~> 0.1.1"
    spec.add_dependency "paint", "~> 2.3"
    spec.add_dependency "thor", "~> 1.2", ">= 1.2.2"
  
    spec.add_development_dependency "rubocop", "~> 1.52"
    
    spec.executables   = ["locotool"]
  end
  