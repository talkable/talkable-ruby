require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
WebMock.disable_net_connect!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'talkable'

RSpec.configure do |config|
  config.order = "random"

  config.filter_run(:focus) unless ENV['TDDIUM']
  config.run_all_when_everything_filtered = true
end
