require 'spec_helper'

describe Talkable::JSONStruct do
  let(:two_level_hash) { {foo: 'bar', baz: {qux: 'quux'}, corge: ['grault', 'garply']}}
  subject { Talkable::JSONStruct.new(two_level_hash) }

  describe "#new" do
    it "recurcively creates struct" do
      expect(subject.baz).not_to be_kind_of(Hash)
      expect(subject.baz.qux).to eq('quux')
      expect(subject.corge).to be_kind_of(Array)
    end
  end

  describe "#to_h" do
    it "recurcively converts to hash" do
      expect(subject.to_h).to eq(two_level_hash)
    end

    it "doesn't modify struct" do
      hash = subject.to_h
      hash[:foo] = 'new_bar'
      expect(subject.foo).to eq('bar')
    end
  end

  describe "#[]" do
    it 'allows symbols and strings' do
      expect(subject[:baz]['qux']).to eq('quux')
    end
  end

  describe "#[]=" do
    it 'allows symbols and strings' do
      subject['baz'][:qux] = 'new_quux'
      expect(subject.baz.qux).to eq('new_quux')
    end
  end

end
