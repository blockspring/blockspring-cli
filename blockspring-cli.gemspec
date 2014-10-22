# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blockspring/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "blockspring-cli"
  spec.version       = Blockspring::CLI::VERSION
  spec.authors       = ["Blockspring"]
  spec.email         = ["founders@blockspring.com"]
  spec.summary       = "This is the command line helper for blockspring"
  spec.description   = "This is the command line helper for blockspring"
  spec.homepage      = "http://www.blockspring.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = "blockspring"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "netrc",        "~> 0.7.7"
  spec.add_dependency "rest-client",  "= 1.6.7"
end
