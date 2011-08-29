# -*- mode: ruby; coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'readline-ffi/version'

Gem::Specification.new do |s|
  s.name = "readline-ffi"
  s.version = ReadlineFFI::VERSION
  s.author = "Koichiro Ohba"
  s.email = "koichiro@meadowy.org"
  s.homepage="https://github.com/koichiro/readline-ffi"
  s.summary = "Readline-ffi is a wrapper library of Readline, using Ruby-FFI."
  s.description = s.summary
  s.rubyforge_project = s.name
  #s.files += %w(docs ext/readline.dll test README.rdoc Rakefile)
  s.rdoc_options << '--exclude' << 'ext' << '--main' << 'README'
  s.extra_rdoc_files = ["README.rdoc"]
  s.has_rdoc = true
  s.required_ruby_version = '>= 1.8.7'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n") 
  s.require_paths = ["lib"]
  
  s.add_dependency 'ffi', ['>= 1.0.0']
end
