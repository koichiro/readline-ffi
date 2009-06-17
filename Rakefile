require 'rake'
require 'rubygems'
require 'rake/clean'
require 'fileutils'
include FileUtils

CLEAN.include ["ext/*.{log,c,so,obj,pdb,lib,def,exp,manifest,orig}", "ext/Makefile", "*.gem"]

name="readline-ffi"
version="0.0.1"

desc "Do everything, baby!"
task :default => [:package]

task :package => [:clean,:compile,:makegem]

task :ffi_generate do
  require 'ffi'
  require 'ffi/tools/generator'
  require 'ffi/tools/struct_generator'

  ffi_files = ["lib/readline.rb.ffi"]
  ffi_options = "-Ilib"
  ffi_files.each do |ffi_file|
    
  end
  
end

desc "Build a binary gem for Win32"
task :makegem do
  spec = Gem::Specification.new do |s|
	s.name = %{#{name}}
	s.version = %{#{version}}
    s.author = "Koichiro Ohba"
    s.email = "koichiro@meadowy.org"
    s.homepage="http://kenai.com/projects/readline-ffi"
    s.summary = "Readline-ffi is a wrapper library of Readline, using Ruby-FFI."
    s.description = s.summary
    s.rubyforge_project = s.name
    s.files += %w(docs ext/readline.dll test README.rdoc Rakefile)
	s.rdoc_options << '--exclude' << 'ext' << '--main' << 'README'
	s.extra_rdoc_files = ["README.rdoc"]
	s.has_rdoc = true
#	s.require_path = 'ext'
#	s.autorequire = 'mysql'
    s.required_ruby_version = '>= 1.8.6'
  end

  Gem::manage_gems
  Gem::Builder.new(spec).build
end

desc "mspec"
task :spec do
  sh "mspec -t j spec"
end
