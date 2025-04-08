require 'spec_helper'

describe Talkable::Configuration do
  subject { described_class.new }

  it 'has defaults' do
    expect(subject.server).to eq("https://www.talkable.com")
    expect(subject.api_key).to be_nil
    expect(subject.site_slug).to be_nil
    expect(subject.read_timeout).to eq(5)
    expect(subject.open_timeout).to eq(5)
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
      }.to raise_error(described_class::UnknownOptionError)
    end

    context 'with timeout' do
      before { subject.apply(timeout: 2) }

      it 'changes configuration' do
        expect(subject.read_timeout).to eq(2)
        expect(subject.open_timeout).to eq(2)
      end
    end
  end

  describe '#reset' do
    before do
      subject.apply(api_key: 'some-api-key',
                    site_slug: 'some-site-slug',
                    server: 'http://some-server.com',
                    timeout: 13,
                    read_timeout: 12,
                    open_timeout: 11,
                    js_integration_library: 'some-js-library')
    end

    it 'changes configuration' do
      subject.reset

      expect(subject.server).to eq(described_class::DEFAULT_SERVER)
      expect(subject.api_key).to be_nil
      expect(subject.site_slug).to be_nil
      expect(subject.read_timeout).to eq(5)
      expect(subject.open_timeout).to eq(5)
      expect(subject.js_integration_library).to eq("//d2jjzw81hqbuqv.cloudfront.net/integration/clients/.min.js")
    end

    context 'with environment variables' do
      before do
        allow(ENV).to receive(:[]).with('TALKABLE_API_KEY').and_return('some-api-key')
        allow(ENV).to receive(:[]).with('TALKABLE_SITE_SLUG').and_return('some-site-slug')
      end

      it 'changes configuration' do
        subject.reset

        expect(subject.server).to eq(described_class::DEFAULT_SERVER)
        expect(subject.api_key).to eq('some-api-key')
        expect(subject.site_slug).to eq('some-site-slug')
        expect(subject.read_timeout).to eq(5)
        expect(subject.open_timeout).to eq(5)
        expect(subject.js_integration_library).to eq("//d2jjzw81hqbuqv.cloudfront.net/integration/clients/some-site-slug.min.js")
      end
    end
  end
end
