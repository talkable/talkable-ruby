require 'spec_helper'

describe Talkable::API::Origin do
  describe ".create" do
    let(:type) { described_class::PURCHASE }
    let(:params) {{
      email: 'customer@domain.com',
      order_number: '123',
      subtotal: 34.56,
    }}

    before do
      stub_request(:post, %r{.*api/v2/origins.*}).
        with(body: /.*"type":"Purchase".*"traffic_source":"talkable-gem","email":"customer@domain.com","order_number":"123","subtotal":34.56.*/).
        to_return(body: '{"ok":true,"result":{"origin":{"id":1024}}}')
    end

    it "success" do
      expect(described_class.create(type, params)).to eq({origin: {id: 1024}})
    end
  end
end
