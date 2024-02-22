# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ach/version"

Gem::Specification.new do |s|
  s.name        = "ach"
  s.version     = ACH::VERSION.dup
  s.summary     = "Helper for building ACH files"
  s.description = "ach is a Ruby helper for building and parsing ACH files. In particular, it helps with field order and alignment, and adds padding lines to end of file."
  s.email       = "henriquegasques@gmail.com"
  s.homepage    = "https://github.com/rubyritas/ach"
  s.authors     = ["Jared Morgan", "Josh Puetz"]
  s.license     = "MIT"

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/rubyritas/ach/issues",
    "changelog_uri" => "https://github.com/rubyritas/ach/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://github.com/rubyritas/ach/blob/main/README.md",
    "homepage_uri" => "https://github.com/rubyritas/ach",
    "source_code_uri" => "https://github.com/rubyritas/ach"
  }

  s.extra_rdoc_files = ["README.md"]

  s.files        = Dir.glob('lib/**/*') + %w{MIT-LICENSE README.md}
  s.test_files   = Dir.glob('examples/**/*')
  s.require_path = 'lib'

  s.required_ruby_version = ">= 2.0.0"

  s.add_development_dependency('appraisal')
  s.add_development_dependency('autotest')
  s.add_development_dependency('rake', '>= 12.3.3')
  s.add_development_dependency('rspec', '~> 3.2')

  s.add_runtime_dependency('holidays', '>= 3.1')
end
