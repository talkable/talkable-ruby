require 'spec_helper'

describe Talkable::Configuration do
  subject { Talkable::Configuration.new }

  it 'has defaults' do
    expect(subject.server).to eq("https://www.talkable.com")
    expect(subject.api_key).to be_nil
    expect(subject.site_slug).to be_nil
  end

  it 'takes defaults from environment variables' do
    allow(ENV).to receive(:[]).with("TALKABLE_API_KEY").and_return("some-api-key")
    allow(ENV).to receive(:[]).with("TALKABLE_SITE_SLUG").and_return("some-site-slug")
    expect(subject.api_key).to eq("some-api-key")
    expect(subject.site_slug).to eq("some-site-slug")
  end

  it 'has default js integration link' do
    expect(subject.js_integration_library).not_to be_nil
  end

  describe "#apply" do
    before { subject.apply(server: 'http://some-server.com') }

    it 'changes configuration' do
      expect(subject.server).to eq('http://some-server.com')
    end

    it 'raises for unknown options' do
      expect {
        subject.apply(not_existing_option: 'value')
      }.to raise_error(Talkable::Configuration::UnknownOptionError)
    end
  end
end
