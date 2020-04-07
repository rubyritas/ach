#!/usr/bin/env rake

require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'ach/version'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default  => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ACH #{ACH::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :build do
  system 'gem build ach.gemspec'
end

task :release => :build do
  system "gem push ach-#{ACH::VERSION}.gem"
end
