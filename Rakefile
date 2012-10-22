require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ach"
    gem.summary = %{Helper for building ACH files in Ruby}
    gem.description = <<EOF
ach is a Ruby helper for builder ACH files. In particular, it helps with field
order and alignment, and adds padding lines to end of file.
EOF
    gem.email = "jmorgan@morgancreative.net"
    gem.homepage = "http://github.com/jm81/ach"
    gem.authors = ["Jared Morgan", "Josh Puetz"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/*test*.rb']
    t.verbose = true
  end

require 'micronaut/rake_task'
Micronaut::RakeTask.new(:examples) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.ruby_opts << '-Ilib -Iexamples'
end

Micronaut::RakeTask.new(:rcov) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.rcov_opts = '-Ilib -Iexamples'
  examples.rcov = true
end

task :default => :examples

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ACH #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end



