require 'spec_helper'

describe Talkable::API::Visitor do
  describe ".create" do
    let(:uuid) { "8fdf75ac-92b4-479d-9974-2f9c64eb2e09" }
    let(:params) { {uuid: uuid} }

    before do
      stub_request(:post, /.*api\/v2\/visitors.*/).
        with(body: /.*\"data\":{\"uuid\":\"#{uuid}\"}.*/).
        to_return(body: '{"ok": true, "result": {"uuid":"8fdf75ac-92b4-479d-9974-2f9c64eb2e09"}}')
    end

    it "success" do
      expect(Talkable::API::Visitor.create(params)).to eq({uuid: uuid})
    end
  end
end
