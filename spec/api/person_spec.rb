require 'spec_helper'

describe Talkable::API::Person do
  let(:api_key) { 'api_key' }
  let(:site_slug) { 'site_slug' }
  let(:server) { 'https://www.talkable.com' }
  let(:email) { 'customer@email.com' }
  let(:base_url) { "#{server}/api/v2/people/#{email}" }

  before do
    Talkable.configure(api_key: api_key, site_slug: site_slug, server: server)
  end

  subject { described_class }

  describe '.find' do
    before do
      stub_request(:get, base_url).
        with(query: { site_slug: site_slug },
             headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: '{"ok": true, "result": {"person":{"username":"batman"}}}')
    end

    it 'returns success' do
      expect(subject.find(email)).to eq({person: {username: 'batman'}})
    end
  end

  describe '.update' do
    let(:new_username) { "new_name" }
    before do
      stub_request(:put, base_url).
        with(body: hash_including({"data":{"username": new_username}}),
             headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: '{"ok": true, "result": {"person":{"username":"new_name"}}}')
    end

    it 'returns success' do
      expect(subject.update(email, username: new_username)).to eq({person: {username: new_username}})
    end
  end

  describe '.unsubscribe' do
    before do
      stub_request(:post, "#{base_url}/unsubscribe").
        with(headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: '{"ok": true, "result": {"person":{"username":"batman", "unsubscribed_at":"2016-09-06T16:14:25.000Z"}}}')
    end

    it 'returns success' do
      expect(subject.unsubscribe(email)).to eq({person: {username: 'batman', unsubscribed_at: '2016-09-06T16:14:25.000Z'}})
    end
  end

  describe '.anonymize' do
    before do
      stub_request(:post, "#{base_url}/anonymize").
        with(headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: '{"ok": true, "result": {"person":{"username":null, "first_name": null, "last_name": null}}}')
    end

    it 'returns success' do
      expect(subject.anonymize(email)).to eq({person: {username: nil, first_name: nil, last_name: nil}})
    end
  end

  describe '.personal_data' do
    before do
      stub_request(:get, "#{base_url}/personal_data").
        with(query: { site_slug: site_slug },
             headers: { Authorization: "Bearer #{api_key}" }).
        to_return(body: '{"ok": true, "result": {"person":{"username":"batman", "origins": [{"type": "AffiliateMember"}]}}}')
    end

    it 'returns success' do
      expect(subject.personal_data(email)).to eq({person: {username: 'batman', origins: [{type: 'AffiliateMember'}]}})
    end
  end
end
