# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'devise_revokable/version'

Gem::Specification.new do |s|
  s.name         = "devise_revokable"
  s.version      = DeviseRevokable::VERSION.dup
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Travis Cox"]
  s.email        = "travis@e9digital.com"
  s.homepage     = "https://github.com/e9digital/devise_revokable"
  s.summary      = "A revocation strategy for Devise"
  s.description  = ""

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency('rails', '~> 3.0.0')
  s.add_runtime_dependency('devise', '~> 1.1.5')
end
