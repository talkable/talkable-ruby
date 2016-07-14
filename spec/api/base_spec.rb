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

    def stub_api_request
      api_params = params.merge({api_key: api_key, site_slug: site_slug})
      stub_request(http_method, "#{server}/api/#{version}/path").
        with(http_method == :get ? {query: api_params} : {body: api_params.to_json})
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
      }).to_return(body:'{"ok": true, "result":""}', status: 200)

      expect { request }.not_to raise_error
    end

    it 'raises on network error' do
      stub_api_request.to_raise(Errno::ECONNREFUSED)
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
        expect(request).to eq({'key' => 'value'})
      }.not_to raise_error
    end
  end

  describe '.get' do
    let(:request) { Talkable::API::Base.get(path, params) }
    it_behaves_like 'api request', :get
  end

  describe '.post' do
    let(:request) { Talkable::API::Base.post(path, params) }
    it_behaves_like 'api request', :post
  end
end
