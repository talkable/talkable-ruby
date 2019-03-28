require 'spec_helper'

describe Talkable::Configuration do
  subject { Talkable::Configuration.new }

  it 'has defaults' do
    expect(subject.server).to eq("https://www.talkable.com")
    expect(subject.api_key).to be_nil
    expect(subject.site_slug).to be_nil
    expect(subject.read_timeout).to eq(60)
    expect(subject.open_timeout).to eq(60)
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

    context 'with timeout' do
      before { subject.apply(timeout: 2) }

      it 'changes configuration' do
        expect(subject.read_timeout).to eq(2)
        expect(subject.open_timeout).to eq(2)
      end
    end
  end

  describe "#clean" do
    before do
      subject.apply(api_key: 'api_key',
                    site_slug: 'site_slug',
                    server: 'http://some-server.com',
                    read_timeout: 12,
                    open_timeout: 10)
    end

    it 'changes configuration' do
      subject.clean

      expect(subject.server).to eq(Talkable::Configuration::DEFAULT_SERVER)
      expect(subject.api_key).to be_nil
      expect(subject.site_slug).to be_nil
      expect(subject.read_timeout).to eq(60)
      expect(subject.open_timeout).to eq(60)
    end
  end
end
