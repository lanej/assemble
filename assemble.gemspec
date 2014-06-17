# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assemble/version'

Gem::Specification.new do |spec|
  spec.name          = "assemble"
  spec.version       = Assemble::VERSION
  spec.authors       = ["Josh Lane"]
  spec.email         = ["me@joshualane.com"]
  spec.summary       = %q{Rally REST API Client}
  spec.description   = %q{Cistern-based client for Rally Dev}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "cistern", "~> 0.8"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.9"
  spec.add_dependency "addressable"
end
