require 'spec_helper'

describe Talkable::API::Visitor do
  describe ".create" do
    let(:uuid) { "8fdf75ac-92b4-479d-9974-2f9c64eb2e09" }
    let(:params) { {uuid: uuid} }

    before { stub_uuid_request(uuid) }

    it "success" do
      expect(described_class.create(params)).to eq({uuid: uuid})
    end
  end
end
