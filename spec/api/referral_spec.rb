require 'spec_helper'

describe Talkable::API::Referral do
  let(:origin_slug) { 'order_number' }
  let(:status) { Talkable::API::Referral::APPROVED }

  describe '.update' do
    before do
      stub_request(:put, /.*api\/v2\/origins\/order_number\/referral/).
        with(body: /.*{\"data\":{\"status\":\"approved\"}.*/).
        to_return(body: '{"ok": true}')
    end

    it "success" do
      expect(Talkable::API::Referral.update(origin_slug, status)).to be_nil
    end
  end
end
