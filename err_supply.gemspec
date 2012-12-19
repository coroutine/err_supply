# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "err_supply/version"

Gem::Specification.new do |s|
  s.name        = "err_supply"
  s.version     = ErrSupply::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Coroutine", "John Dugan"]
  s.email       = ["gems@coroutine.com"]
  s.homepage    = "http://github.com/coroutine/err_supply"
  s.summary     = %q{Simple, beautiful error messages for Rails.}
  s.description = %q{Simple, beautiful error messages for Rails. Err_supply unpacks and rekeys the standard Rails error hash to make applying error messages to your views dead simple. Even better, because the library cures Rails' brain-damaged way of recording errors from nested resources/attributes, err_supply works with both simple and complex forms.}

  s.add_dependency "rails", ">= 3.0.0"
  s.add_development_dependency "rspec", ">= 2.0.0"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end