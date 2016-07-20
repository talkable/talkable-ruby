require 'spec_helper'
require 'rack/mock'

describe Talkable::Middleware do
  let(:uuid) { 'fe09af8c-1801-4fa3-998b-ddcbe0e052e5' }
  let(:app) { ->(env) { [200, env, Talkable.visitor_uuid] } }
  subject { Talkable::Middleware.new(app) }

  shared_examples 'middleware' do |uuid|
    it 'sets talkable_visitor_uuid in cookie' do
      status, headers, body = subject.call(env)
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

end
