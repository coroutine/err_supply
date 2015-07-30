# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'err_supply/version'

Gem::Specification.new do |spec|
  spec.name        = 'err_supply'
  spec.version     = ErrSupply::VERSION
  spec.authors     = ['Coroutine', 'John Dugan']
  spec.email       = ['gems@coroutine.com']
  spec.summary     = %q{Simple, beautiful error messages for Rails.}
  spec.description = %q{Simple, beautiful error messages for Rails. Err_supply unpacks and rekeys the standard Rails error hash to make applying error messages to your views dead simple. Even better, because the library cures Rails' brain-damaged way of recording errors from nested resources/attributes, err_supply works with both simple and complex forms.}
  spec.homepage    = 'http://github.com/coroutine/err_supply'
  spec.licenses    = ['MIT']

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.0.0'

  spec.add_development_dependency 'rspec', '>= 2.0.0'
end
