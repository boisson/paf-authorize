# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proteste_authorize/version'

Gem::Specification.new do |spec|
  spec.name          = "proteste_authorize"
  spec.version       = ProtesteAuthorize::VERSION
  spec.authors       = ["rodrigo toledo"]
  spec.email         = ["rtoledo@proteste.org.br"]
  spec.description   = %q{Give permissions by access control 2 webservice}
  spec.summary       = %q{Give permissions by access control 2 webservice}
  spec.homepage      = ""

  spec.files         = Dir["README.md", "lib/**/*"]
  spec.test_files    = Dir["test/**/*.rb"]
  spec.require_paths = ["lib"]
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) } 

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency('actionpack')
  spec.add_runtime_dependency('nokogiri')
end
