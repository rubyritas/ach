require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'ach'
require 'date'

Dir['./spec/support/fields/*.rb'].sort.each { |f| require f}
Dir['./spec/support/records/*.rb'].sort.each { |f| require f}

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
end
