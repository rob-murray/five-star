# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "five-star/version"

Gem::Specification.new do |spec|
  spec.name          = "five-star"
  spec.version       = FiveStar::VERSION
  spec.authors       = ["Rob Murray"]
  spec.email         = ["robmurray17@gmail.com"]

  spec.summary       = %q{:star: A generic rating library :star:}
  spec.description   = %q{A Rating system for your Ruby objects; Rate an object with one or more rating classifications.}
  spec.homepage      = "https://github.com/rob-murray/five-star"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "byebug" if RUBY_PLATFORM != 'java'
end
