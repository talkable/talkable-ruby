require 'spec_helper'

describe Talkable::API::Base do
  shared_examples 'api request' do |http_method|
    let(:server)      { 'http://example.com' }
    let(:site_slug)   { 'site_slug' }
    let(:api_key)     { 'api_key' }
    let(:version)     { Talkable::API::VERSION }
    let(:http_method) { http_method }
    let(:path)        { '/path' }
    let(:params)      { {key1: :value1, key2: :value2} }
    let(:api_params)  { params.merge(site_slug: site_slug) }

    def stub_api_request
      stub_request(http_method, "#{server}/api/#{version}/path").with(params_stub)
    end

    before do
      Talkable.configure do |config|
        config.server     = server
        config.site_slug  = site_slug
        config.api_key    = api_key
      end
    end

    it 'has custom user agent and json headers' do
      stub_api_request.with(headers: {
        'User-Agent'    => "Talkable Gem/#{Talkable::VERSION}",
        'Content-Type'  => 'application/json',
        'Accept'        => 'application/json',
        'Authorization' => "Bearer #{api_key}",
      }).to_return(body:'{"ok": true, "result":""}', status: 200)

      expect { request }.not_to raise_error
    end

    it 'raises on network error' do
      stub_api_request.to_raise(Errno::ECONNREFUSED)
      expect { request }.to raise_error(Talkable::API::NetworkError)
    end

    it 'raises on timeout error' do
      stub_api_request.to_timeout
      expect { request }.to raise_error(Talkable::API::NetworkError)
    end

    it 'raises on server error' do
      stub_api_request.to_return(status: 500)
      expect { request }.to raise_error(Talkable::API::NetworkError)
    end

    it 'raises on invalid responses' do
      stub_api_request.to_return(body: '{{{')
      expect { request }.to raise_error(Talkable::API::BadRequest)
    end

    it 'raises error message on client error' do
      stub_api_request.to_return(
        status: 404,
        body: '{"ok": false, "error_message":"NotFound"}'
      )
      expect{ request }.to raise_error("NotFound")
    end

    it 'raises error message on success request' do
      stub_api_request.to_return(
        status: 200,
        body: '{"ok": false, "error_message":"InvalidData"}'
      )
      expect{ request }.to raise_error("InvalidData")
    end

    it 'responses result' do
      stub_api_request.to_return(
        status: 200,
        body: '{"ok": true, "result":{"key": "value"}}'
      )
      expect {
        expect(request).to eq({key: 'value'})
      }.not_to raise_error
    end
  end

  describe '.get' do
    let(:request) { Talkable::API::Base.get(path, params) }
    let(:params_stub) { {query: api_params} }
    it_behaves_like 'api request', :get
  end

  describe '.post' do
    let(:request) { Talkable::API::Base.post(path, params) }
    let(:params_stub) { {body: api_params.to_json} }

    it_behaves_like 'api request', :post
  end

  describe '.put' do
    let(:request) { Talkable::API::Base.put(path, params) }
    let(:params_stub) { {body: api_params.to_json} }

    it_behaves_like 'api request', :put
  end
end
