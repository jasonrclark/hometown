# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hometown/version'

Gem::Specification.new do |spec|
  spec.name          = "hometown"
  spec.version       = Hometown::VERSION
  spec.authors       = ["Jason R. Clark"]
  spec.email         = ["jason@jasonrclark.com"]
  spec.summary       = %q{Track object creation}
  spec.description   = %q{Track object creation to stamp out pesky leaks.}
  spec.homepage      = "http://github.com/jasonrclark/hometown"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
