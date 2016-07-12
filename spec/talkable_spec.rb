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
end
