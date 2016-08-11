require 'spec_helper'
require 'rack/mock'

describe Talkable::Middleware do
  let(:uuid) { 'fe09af8c-1801-4fa3-998b-ddcbe0e052e5' }
  let(:app) { ->(env) { [200, env, Talkable.visitor_uuid] } }
  subject { Talkable::Middleware.new(app) }

  shared_examples 'middleware' do |uuid|
    it 'injects talkable_visitor_uuid in cookie' do
      _, headers, _ = subject.call(env)
      expect(headers['Set-Cookie']).to match(/talkable_visitor_uuid=#{uuid};\spath=\/;/)
    end
  end

  context 'when new visitor' do
    let(:env) { Rack::MockRequest.env_for("/") }
    before { stub_uuid_request(uuid) }

    it_behaves_like 'middleware', 'fe09af8c-1801-4fa3-998b-ddcbe0e052e5'
  end

  context 'when cookie already exists' do
    let(:path) { '/' }
    let(:env) do
      env = Rack::MockRequest.env_for(path)
      env['HTTP_COOKIE'] = "talkable_visitor_uuid=#{uuid}"
      env
    end

    it_behaves_like 'middleware', 'fe09af8c-1801-4fa3-998b-ddcbe0e052e5'

    context 'and request query has talkable_visitor_uuid' do
      let(:param_uuid) { '40a852bf-8887-4ce7-b3f4-e08ff327d74f' }
      let(:path) { "/?talkable_visitor_uuid=#{param_uuid}" }

      it_behaves_like 'middleware', '40a852bf-8887-4ce7-b3f4-e08ff327d74f'
    end
  end

  context 'when html content' do
    let(:env) do
      env = Rack::MockRequest.env_for("/")
      env['Content-Type'] = 'text/html; charset=utf-8'
      env
    end
    let(:app) { ->(env) { [200, env, ['<head><title>title</title></head><body><h1>title</h1></body>']] } }

    before {
      stub_uuid_request(uuid)
      Talkable.configure(site_slug: 'test-middleware')
    }

    it 'injects sync url in body' do
      _, _, response = subject.call(env)
      expect(response.body.first).to include("https://www.talkable.com/public/1x1.gif?current_visitor_uuid=#{uuid}")
    end

    it 'injects integration js library' do
      _, _, response = subject.call(env)
      expect(response.body.first).to include('<script src="//d2jjzw81hqbuqv.cloudfront.net/integration/clients/test-middleware.min.js" type="text/javascript"></script>')
      expect(response.body.first).to include(%Q{
<script>
  window._talkableq = window._talkableq || [];
  _talkableq.push(['init', {
    site_id: 'test-middleware'
  }]);
</script>
      })
    end
  end

end
