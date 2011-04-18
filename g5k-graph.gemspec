# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'grid5000/graph'
 
Gem::Specification.new do |s|
  s.name                      = "g5k-graph"
  s.version                   = Grid5000::Graph::VERSION
  s.platform                  = Gem::Platform::RUBY
  s.required_ruby_version     = '>= 1.8'
  s.required_rubygems_version = ">= 1.3"
  s.authors                   = ["Cyril Rohr"]
  s.email                     = ["cyril.rohr@gmail.com"]
  s.executables               = ["g5k-graph"]
  s.homepage                  = "http://github.com/crohr/g5k-graph"
  s.summary                   = "Graph your Grid'5000 metrics"
  s.description               = "Graph your Grid'5000 metrics"
 
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  
  s.require_path = 'lib'
end
