# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'ach/version'

Gem::Specification.new do |s|
  s.name        = 'ach'
  s.version     = ACH::VERSION.dup
  s.summary     = 'Helper for building ACH files'
  s.description = 'ach is a Ruby helper for building and parsing ACH files. In particular, it helps with field order and alignment, and adds padding lines to end of file.'
  s.email       = 'jmorgan@morgancreative.net'
  s.homepage    = 'https://github.com/jm81/ach'
  s.authors     = ['Jared Morgan', 'Josh Puetz']

  s.extra_rdoc_files = ['README.md']

  s.files        = Dir.glob('lib/**/*') + %w{MIT-LICENSE README.md}
  s.test_files   = Dir.glob('examples/**/*')
  s.require_path = 'lib'

  s.add_development_dependency('appraisal')
  s.add_development_dependency('autotest')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 3.2')

  s.add_runtime_dependency('holidays', '>= 1.2.0', '<= 6.4.0')
end
