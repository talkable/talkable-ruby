require 'spec_helper'

describe Talkable do
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
