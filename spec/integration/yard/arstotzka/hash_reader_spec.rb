# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::HashReader do
  subject(:reader) { described_class.new(options) }

  describe '#hash' do
    let(:klass)    { Arstotzka::Fetcher::Dummy }
    let(:json)     { { key: 'value' } }
    let(:instance) { klass.new(json) }
    let(:options)  { { instance: instance } }

    context 'when no extra options are given' do
      it 'reads hash from instance json method' do
        expect(reader.hash).to eq(json)
      end
    end

    context 'when fetching from instance variable' do
      let(:klass)   { Arstotzka::Fetcher::NoAccessor }
      let(:options) { { instance: instance, json: :@hash } }

      it 'reads hash from instance variable' do
        expect(reader.hash).to eq(json)
      end
    end

    context 'when fetching from class variable' do
      let(:klass) { Arstotzka::Fetcher::ClassVariable }
      let(:options)  { { instance: instance, json: :@@json } }
      let(:instance) { klass.new }

      before { klass.json = json }

      it 'reads hash from class variable' do
        expect(reader.hash).to eq(json)
      end
    end
  end
end
