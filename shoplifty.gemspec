# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shoplifty/version'

Gem::Specification.new do |spec|
  spec.name          = "shoplifty"
  spec.version       = Shoplifty::VERSION
  spec.authors       = ["Leo Bossmann"]
  spec.email         = ["leo@noni-mode.de"]
  spec.description   = "Shopify's other API"
  spec.summary       = "Simulates a normal backend login to access Shopify's private backend API"
  spec.homepage      = "https://github.com/leobossmann/shoplifty"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end