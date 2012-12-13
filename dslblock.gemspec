# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dslblock/version'

Gem::Specification.new do |gem|
  gem.name          = "dslblock"
  gem.version       = DSLBlock::VERSION
  gem.authors       = ["Christian Rost"]
  gem.email         = ["chr@baltic-online.de"]
  gem.description   = %q{Helper-Class for creating universal DSL blocks}
  gem.summary       = %q{Helper-Class for creating universal DSL blocks}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  
  %w{ activesupport }.each do |gem|
    s.add_dependency gem, ['>= 3.0.0']
  end
  
end
