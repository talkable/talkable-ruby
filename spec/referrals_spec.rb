require 'spec_helper'

describe Talkable::API::Referral do
  shared_examples 'update referral method' do |status|
    let(:origin_slug) { "test-site" }

    before do
      stub_request(:put, %r{.*api/v2/origins/test-site/referral}).
        with(body: /.*{"data":{"status":"#{status}"}.*/).
        to_return(body: '{"ok":true}')
    end

    it "success" do
      expect(described_class.update(origin_slug, status)).to be_nil
    end
  end

  describe '#approve_referral' do
    it_behaves_like 'update referral method', described_class::APPROVED
  end

  describe '#void_referral' do
    it_behaves_like 'update referral method', described_class::VOIDED
  end

  describe '#unblock_referral' do
    it_behaves_like 'update referral method', described_class::UNBLOCKED
  end
end
