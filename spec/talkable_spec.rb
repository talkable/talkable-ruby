require 'spec_helper'

describe Talkable do
  it 'has a version number' do
    expect(Talkable::VERSION).not_to be nil
  end

  describe '#configuration' do
    subject { Talkable.configuration }
    it { is_expected.to be_an_instance_of(Talkable::Configuration) }
  end

  describe '#configure' do
    subject { Talkable.configuration }
    context 'with hash' do
      before { Talkable.configure(api_key: 'some-api-key') }

      it 'changes configuration' do
        expect(subject.api_key).to eq('some-api-key')
      end
    end

    context 'with block' do
      before do
        Talkable.configure do |config|
          config.site_slug = 'some-site-slug'
        end
      end

      it 'changes configuration' do
        expect(subject.site_slug).to eq('some-site-slug')
      end
    end
  end

  describe '#visitor_uuid' do
    it 'uses threads' do
      allow(Thread.current).to receive(:[]).with(Talkable::UUID).and_return("some-uuid")
      expect(Talkable.visitor_uuid).to eq('some-uuid')
    end
  end

  describe '#visitor_uuid=' do
    it 'uses threads' do
      allow(Thread.current).to receive(:[]=).with(Talkable::UUID, 'some-uuid')
      Talkable.visitor_uuid = 'some-uuid'
    end
  end

  describe '#with_uuid_and_url' do
    it 'retains and releases uuid & url' do
      Talkable.with_uuid_and_url('fe09af8c-1801-4fa3-998b-ddcbe0e052e5', 'http://example.com') do
        Talkable.with_uuid_and_url('40a852bf-8887-4ce7-b3f4-e08ff327d74f', 'http://example.com/invite') do
          expect(Talkable.current_url).to eq('http://example.com/invite')
          expect(Talkable.visitor_uuid).to eq('40a852bf-8887-4ce7-b3f4-e08ff327d74f')
        end
        expect(Talkable.current_url).to eq('http://example.com')
        expect(Talkable.visitor_uuid).to eq('fe09af8c-1801-4fa3-998b-ddcbe0e052e5')
      end
      expect(Talkable.current_url).to be_nil
      expect(Talkable.visitor_uuid).to be_nil
    end

    it 'returns result of given block' do
      expect(
        Talkable.with_uuid_and_url('40a852bf-8887-4ce7-b3f4-e08ff327d74f', 'http://example.com') do
          "result"
        end
      ).to eq("result")
    end
  end

  describe '#find_or_generate_uuid' do
    let(:uuid) { 'fe09af8c-1801-4fa3-998b-ddcbe0e052e5' }

    it 'makes API call' do
      stub_uuid_request(uuid)
      expect(Talkable.find_or_generate_uuid).to eq(uuid)
    end

    context 'when uuid was assigned' do
      before do
        allow(Talkable).to receive(:visitor_uuid).and_return(uuid)
      end

      it 'returns uuid' do
        expect(Talkable.find_or_generate_uuid).to eq(uuid)
      end
    end
  end
end
