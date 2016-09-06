require 'spec_helper'

describe Talkable::API::Reward do
  describe ".find" do
    let(:visitor_uuid) { "8fdf75ac-92b4-479d-9974-2f9c64eb2e09" }

    before do
      stub_request(:get, /.*api\/v2\/rewards.*visitor_uuid=8fdf75ac-92b4-479d-9974-2f9c64eb2e09/).
        to_return(body: '{"ok": true, "result": {"rewards": [{"id":128}]}}')
    end

    it "success" do
      result = Talkable::API::Reward.find({visitor_uuid: visitor_uuid})
      expect(result[:rewards]).to be_kind_of(Array)
      expect(result[:rewards].first).to eq({id: 128})
    end
  end
end
