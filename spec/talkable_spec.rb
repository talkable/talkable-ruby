require 'spec_helper'

describe Talkable do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  describe '.configuration' do
    subject { described_class.configuration }
    it { is_expected.to be_an_instance_of(described_class::Configuration) }
  end

  describe '.configure' do
    subject { described_class.configuration }

    context 'with hash' do
      before { described_class.configure(api_key: 'some-api-key') }

      it 'changes configuration' do
        expect(subject.api_key).to eq('some-api-key')
      end
    end

    context 'with block' do
      before do
        described_class.configure do |config|
          config.site_slug = 'some-site-slug'
        end
      end

      it 'changes configuration' do
        expect(subject.site_slug).to eq('some-site-slug')
      end
    end

    context 'when there were some configuration before' do
      before do
        subject.apply(api_key: 'some-api-key',
                      site_slug: 'some-site-slug',
                      server: 'http://some-server.com')
        described_class.configure(api_key: 'other-api-key')
      end

      it 'does not remove previous configs' do
        expect(subject.site_slug).to eq('some-site-slug')
        expect(subject.server).to eq('http://some-server.com')
      end

      it 'changes configuration' do
        expect(subject.api_key).to eq('other-api-key')
      end
    end
  end

  describe '.visitor_uuid' do
    it 'uses threads' do
      allow(Thread.current).to receive(:[]).with(Talkable::UUID).and_return("some-uuid")
      expect(described_class.visitor_uuid).to eq('some-uuid')
    end
  end

  describe '.visitor_uuid=' do
    it 'uses threads' do
      allow(Thread.current).to receive(:[]=).with(Talkable::UUID, 'some-uuid')
      described_class.visitor_uuid = 'some-uuid'
    end
  end

  describe '.with_uuid_and_url' do
    it 'retains and releases uuid & url' do
      described_class.with_uuid_and_url('fe09af8c-1801-4fa3-998b-ddcbe0e052e5', 'http://example.com') do
        described_class.with_uuid_and_url('40a852bf-8887-4ce7-b3f4-e08ff327d74f', 'http://example.com/invite') do
          expect(described_class.current_url).to eq('http://example.com/invite')
          expect(described_class.visitor_uuid).to eq('40a852bf-8887-4ce7-b3f4-e08ff327d74f')
        end
        expect(described_class.current_url).to eq('http://example.com')
        expect(described_class.visitor_uuid).to eq('fe09af8c-1801-4fa3-998b-ddcbe0e052e5')
      end
      expect(described_class.current_url).to be_nil
      expect(described_class.visitor_uuid).to be_nil
    end

    it 'returns result of given block' do
      expect(
        described_class.with_uuid_and_url('40a852bf-8887-4ce7-b3f4-e08ff327d74f', 'http://example.com') do
          "result"
        end
      ).to eq("result")
    end
  end

  describe '.find_or_generate_uuid' do
    let(:uuid) { 'fe09af8c-1801-4fa3-998b-ddcbe0e052e5' }

    it 'generates new uuid' do
      stub_uuid_generation(uuid)
      expect(SecureRandom).to receive(:uuid)
      expect(described_class.find_or_generate_uuid).to eq(uuid)
    end

    context 'when uuid was assigned' do
      before do
        allow(Talkable).to receive(:visitor_uuid).and_return(uuid)
      end

      it 'returns uuid' do
        expect(described_class.find_or_generate_uuid).to eq(uuid)
      end
    end
  end
end
