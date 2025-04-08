require 'spec_helper'

describe Talkable::API do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end
end
