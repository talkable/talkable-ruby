require 'spec_helper'

describe Talkable do
  shared_examples 'integration method' do |method_name|
    let(:origin) { described_class.send(method_name, register_params) }

    before do
      stub_request(:post, %r{.*api/v2/origins.*}).
        to_return(body: '{"ok":true,"result":{"origin":{"id":1024}}}')
    end

    it 'registers origin' do
      expect(origin).to be_kind_of(Talkable::Origin)
      expect(origin.id).to eq(1024)
    end
  end

  describe '#register_affiliate_member' do
    let(:register_params) { {email: 'email@example.com'} }
    it_behaves_like 'integration method', :register_affiliate_member
  end

  describe '#register_purchase' do
    let(:register_params) { {email: 'email@example.com', subtotal: 123.45, order_number: '1001'} }
    it_behaves_like 'integration method', :register_purchase
  end

  describe '#register_event' do
    let(:register_params) { {event_category: 'some_event'} }
    it_behaves_like 'integration method', :register_event
  end
end
