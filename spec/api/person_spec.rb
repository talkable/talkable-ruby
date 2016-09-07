require 'spec_helper'

describe Talkable::API::Person do
  let(:email) { 'customer@email.com' }
  describe ".find" do
    before do
      stub_request(:get, %r{.*api/v2/people/customer@email.com}).
        to_return(body: '{"ok": true, "result": {"person":{"username":"batman"}}}')
    end

    it "success" do
      expect(Talkable::API::Person.find(email)).to eq({person: {username: 'batman'}})
    end
  end

  describe '.update' do
    before do
      stub_request(:put, %r{.*api/v2/people/customer@email.com}).
        with(body: /.*{"data":{"unsubscribed":true}.*/).
        to_return(body: '{"ok": true, "result": {"person":{"username":"batman", "unsubscribed_at":"2016-09-06T16:14:25.000Z"}}}')
    end

    it "success" do
      expect(Talkable::API::Person.update(email, unsubscribed: true)).to eq({person: {username: 'batman', unsubscribed_at: '2016-09-06T16:14:25.000Z'}})
    end
  end
end
