require 'spec_helper'

describe Talkable::API::Origins do
  before do
    Talkable.configure do |config|
      config.server     = 'http://example.com'
      config.site_slug  = 'site'
      config.api_key    = 'api_key'
    end
  end

  describe ".create" do
    let(:type) { Talkable::API::Origins::PURCHASE }
    let(:params) {{
      email: 'customer@domain.com',
      order_number: '123',
      subtotal: 34.56,
    }}

    before do
      stub_request(:post, "http://example.com/api/v2/origins").
        with(body: {
          type: type,
          data: params,
          api_key: 'api_key',
          site_slug: 'site',
        }.to_json).
        to_return(body: '{"ok": true, "result": {"origin":{"id":1024}}}')
    end

    it "success" do
      expect(Talkable::API::Origins.create(type, params)).to eq({'origin' => {'id' => 1024}})
    end
  end
end
