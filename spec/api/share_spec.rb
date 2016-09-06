require 'spec_helper'

describe Talkable::API::Share do
  describe ".create" do
    let(:short_url_code) { 'SAMPLE' }
    let(:channel) { Talkable::API::Share::CHANNEL_SMS }

    before do
      stub_request(:post, /.*api\/v2\/offers\/SAMPLE\/shares.*/).
        with(body: /.*\"channel\":\"sms\".*/).
        to_return(body: '{"ok": true, "result": {"share":{"id":2096}}}')
    end

    it "success" do
      expect(Talkable::API::Share.create(short_url_code, channel)).to eq({share: {id: 2096}})
    end
  end
end
