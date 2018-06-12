require 'spec_helper'

describe Talkable do
  shared_examples 'register origin method' do |method_name|
    let(:origin) { described_class.send(method_name, register_params) }

    before do
      stub_request(:post, %r{.*api/v2/origins.*}).
        to_return(body: '{"ok": true, "result": {"origin":{"id":1024}}}')
    end

    it 'registers origin' do
      expect(origin).to be_kind_of(Talkable::Origin)
      expect(origin.id).to eq(1024)
    end
  end

  shared_examples 'update referral method' do |status|
    let(:origin_slug) { "test-site" }

    before do
      stub_request(:put, %r{.*api/v2/origins/test-site/referral}).
        with(body: /.*{"data":{"status":"#{status}"}.*/).
        to_return(body: '{"ok": true}')
    end

    it "success" do
      expect(Talkable::API::Referral.update(origin_slug, status)).to be_nil
    end
  end

  describe '#register_affiliate_member' do
    let(:register_params) { {email: 'email@example.com'} }
    it_behaves_like 'register origin method', :register_affiliate_member
  end

  describe '#register_purchase' do
    let(:register_params) { {email: 'email@example.com', subtotal: 123.45, order_number: '1001'} }
    it_behaves_like 'register origin method', :register_purchase
  end

  describe '#register_event' do
    let(:register_params) { {event_category: 'some_event'} }
    it_behaves_like 'register origin method', :register_event
  end

  describe '#approve_referral' do
    it_behaves_like 'update referral method', Talkable::API::Referral::APPROVED
  end

  describe '#void_referral' do
    it_behaves_like 'update referral method', Talkable::API::Referral::VOIDED
  end

  describe '#unblock_referral' do
    it_behaves_like 'update referral method', Talkable::API::Referral::UNBLOCKED
  end
end
