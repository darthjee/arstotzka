# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Fetcher do
  subject(:fetcher) do
    described_class.new json, instance, options.merge(path: path)
  end

  let(:path) { '' }
  let(:instance) { Arstotzka::Fetcher::Dummy.new }
  let(:json) { load_json_fixture_file('arstotzka.json') }
  let(:value) { fetcher.fetch }

  context 'when fetching with no options' do
    let(:options) { {} }
    let(:path) { 'id' }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['id'])
    end

    context 'when calling the method twice' do
      before do
        fetcher.fetch
      end

      it 'retrieves attribute from base json' do
        expect(value).to eq(json['id'])
      end
    end

    context 'when changing json value' do
      let!(:old_value) { json['id'] }

      before do
        fetcher.fetch
        json['id'] = 200
      end

      it 'retrieves the new value' do
        expect(value).not_to eq(old_value)
      end
    end
  end

  describe 'flatten options' do
    let(:json) { [[[1, 2], [3, 4]], [[5, 6], [7, 8]]] }

    context 'when flatten option is true' do
      let(:options) { { flatten: true } }

      it 'returns the fetched value flattened' do
        expect(fetcher.fetch).to eq((1..8).to_a)
      end

      context 'when value is not an array' do
        let(:json) { 1 }

        it 'returns the fetched value flattened' do
          expect(fetcher.fetch).to eq(1)
        end
      end
    end

    context 'when flatten option is false' do
      let(:options) { { flatten: false } }

      it 'returns the fetched value non flattened' do
        expect(fetcher.fetch).to eq(json)
      end
    end
  end

  describe 'after option' do
    let(:instance) { MyParser.new(json) }
    let(:json) { [100, 250, -25] }
    let(:options) { { after: :sum } }

    it 'applies after call ' do
      expect(fetcher.fetch).to eq(325)
    end
  end

  describe 'clazz options' do
    let(:path) { 'name' }
    let(:name) { 'Robert' }
    let(:json) { { name: name } }
    let(:options) { { clazz: wrapper } }
    let(:wrapper) { Person }

    it 'wraps the result in an object' do
      expect(fetcher.fetch).to be_a(wrapper)
    end

    it 'sets the wrapper with the fetched value' do
      expect(fetcher.fetch.name).to eq(name)
    end
  end
end
