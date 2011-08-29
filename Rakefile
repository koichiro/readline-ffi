# -*- mode: ruby; coding: utf-8 -*-
require 'rubygems'
require 'bundler'

require 'rake'
require 'rake/clean'
require 'rake/rdoctask'
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

desc "mspec"
task :spec do
  sh "mspec -t j spec"
end
