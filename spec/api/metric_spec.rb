require 'spec_helper'

describe Talkable::API::Metric do
  let(:api_key) { 'api_key' }
  let(:site_slug) { 'site_slug' }
  let(:server) { 'https://www.talkable.com' }
  let(:name) { 'offers' }
  let(:base_url) { "#{server}/api/v2/metrics/#{name}" }
  let(:params) do
    {
      api_key: api_key,
      site_slug: site_slug,
      start_date: '2014-09-01',
      end_date: '2014-10-01',
    }
  end

  before do
    Talkable.configure(api_key: api_key, site_slug: site_slug, server: server)
  end

  subject { described_class }

  describe '.find' do
    context 'with required params' do
      before do
        stub_request(:get, base_url).
          with(query: params).
          to_return(body: %({
                      "ok": true,
                      "result": {
                        "plain": 1234,
                        "formatted": "1234",
                        "result_type": "number"
                      }
                    }))
      end

      it 'returns success' do
        expect(subject.find(name, params)).
          to eq({plain: 1234, formatted: '1234', result_type: 'number'})
      end
    end

    context 'with more params' do
      let(:params) do
        {
          api_key: api_key,
          site_slug: site_slug,
          start_date: '2014-09-01',
          end_date: '2014-10-01',
          campaign_ids: '35944,12345',
          campaign_tags: 'invite,test',
          campaign_status: 'live'
        }
      end

      before do
        stub_request(:get, base_url).
          with(query: params).
          to_return(body: %({
                      "ok": true,
                      "result": {
                        "plain": 1234,
                        "formatted": "1234",
                        "result_type": "number"
                      }
                    }))
      end

      it 'returns success' do
        expect(subject.find(name, params)).
          to eq({plain: 1234, formatted: '1234', result_type: 'number'})
      end
    end

    context 'when name is average_order_value' do
      let(:name) { 'average_order_value' }

      before do
        stub_request(:get, base_url).
          with(query: params).
          to_return(body: %({
                      "ok": true,
                      "result": {
                        "plain": 5432,
                        "formatted": "$5432",
                        "result_type": "money"
                      }
                    }))
      end

      it 'returns success' do
        expect(subject.find(name, params)).
          to eq({plain: 5432, formatted: '$5432', result_type: 'money'})
      end
    end
  end
end
