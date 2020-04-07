# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'ach'
require 'date'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
end
