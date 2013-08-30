# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_util/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_util"
  spec.version       = RailsUtil::VERSION
  spec.authors       = ["Kari Ikonen"]
  spec.email         = ["kikonen@fiksu.com"]
  spec.description   = %q{Small rails utilities}
  spec.summary       = %q{Rails utilities}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'ruby-prof'
  spec.add_dependency 'rails_config'
  spec.add_dependency 'logging'
end
