require 'spec_helper'

describe Talkable::API::Coupon do
  let(:api_key) { 'api_key' }
  let(:site_slug) { 'site_slug' }
  let(:server) { 'https://www.talkable.com' }
  let(:code) { 'COUPON' }
  let(:email) { 'customer@email.com' }
  let(:base_url) { "#{server}/api/v2/coupons/#{code}" }

  before do
    Talkable.configure(api_key: api_key, site_slug: site_slug, server: server)
  end

  subject { described_class }

  describe '.find' do
    before do
      stub_request(:get, base_url).
        with(query: { site_slug: site_slug },
             headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: %({
                    "ok": true,
                    "result": {
                      "talkable_coupon": true,
                      "coupon": {
                        "code":"#{code}",
                        "amount": 10.0
                      }
                    }
                  }))
    end

    it 'returns success' do
      expect(subject.find(code)).to eq({talkable_coupon: true, coupon: {code: code, amount: 10.0}})
    end

    context 'when coupon was not given by Talkable' do
      before do
        stub_request(:get, base_url).
          with(query: { site_slug: site_slug },
               headers: { Authorization: "Bearer #{api_key}" }).
          to_return(body: %({
                      "ok": true,
                      "result": {
                        "talkable_coupon": false
                      }
                    }))
      end

      it 'returns success' do
        expect(subject.find(code)).to eq({talkable_coupon: false})
      end
    end
  end

  describe '.permission' do
    before do
      stub_request(:get, "#{base_url}/permission/#{email}").
        with(query: { site_slug: site_slug },
             headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: %({
                    "ok": true,
                    "result": {
                      "allowed": true,
                      "talkable_coupon": false
                    }
                  }))
    end

    it 'returns success' do
      expect(subject.permission(code, email)).to eq({talkable_coupon: false, allowed: true})
    end
  end
end
