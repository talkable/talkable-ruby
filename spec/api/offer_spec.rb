require 'spec_helper'

describe Talkable::API::Offer do
  describe ".get" do
    let(:id) { 123 }
    let(:params) {{
      sharing_channels: [:facebook, :twitter]
    }}

    before do
      stub_request(:get, /.*api\/v2\/offers\/123.*/).
        to_return(body: '{"ok": true, "result": {"offer":{"id":123}}}')
    end

    it "success" do
      expect(Talkable::API::Offer.find(id, params)).to eq({'offer' => {'id' => id}})
    end
  end
end
