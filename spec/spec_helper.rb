require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
WebMock.disable_net_connect!

require 'talkable'

RSpec.configure do |config|
  config.order = "random"

  config.filter_run(:focus) unless ENV['CI']
  config.run_all_when_everything_filtered = true
end

def stub_uuid_request(uuid)
  stub_request(:post, %r{.*api/v2/visitors.*}).
    to_return(body: %Q{{"ok": true, "result": {"uuid":"#{uuid}"}}})
end

def stub_uuid_generation(uuid)
  allow(SecureRandom).to receive(:uuid).and_return(uuid)
end
