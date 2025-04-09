require 'spec_helper'

describe Talkable::API::Campaign do
  let(:api_key) { 'api_key' }
  let(:site_slug) { 'site_slug' }
  let(:server) { 'https://www.talkable.com' }
  let(:base_url) { "#{server}/api/v2/campaigns" }

  before do
    Talkable.configure(api_key: api_key, site_slug: site_slug, server: server)
  end

  describe '.all' do
    before do
      stub_request(:get, base_url).
        with(query: { site_slug: site_slug },
             headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: %({
                    "ok": true,
                    "result": {
                      "campaigns": [{
                        "id": 111,
                        "name": "API campaign",
                        "is_active": true
                      }]
                    }
                  }))
    end

    it 'returns success' do
      expect(described_class.all).to eq({campaigns: [{id: 111, name: 'API campaign', is_active: true}]})
    end
  end
end
