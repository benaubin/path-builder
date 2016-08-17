# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'path-builder/version'

Gem::Specification.new do |spec|
  spec.name          = "path-builder"
  spec.version       = PathBuilder::VERSION
  spec.authors       = ["Ben"]
  spec.email         = ["ben@bensites.com"]

  spec.summary       = %q{A simple syntax for building url-like paths}
  spec.description   = %q{Paths, but more Rubyish.}
  spec.homepage      = "https://github.com/penne12/path-builder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
