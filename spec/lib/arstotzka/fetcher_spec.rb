# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Fetcher do
  subject(:fetcher) do
    described_class.new options
  end

  let(:options)  { Arstotzka.config.options(options_hash.merge(instance: instance)) }
  let(:instance) { Arstotzka::Fetcher::Dummy.new(json) }
  let(:json)     { load_json_fixture_file('arstotzka.json') }
  let(:value)    { fetcher.fetch }

  context 'when fetching with no options' do
    let(:options_hash) { { key: key } }
    let(:key)          { 'id' }

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
    let(:json)  { { value: value } }
    let(:value) { [[[1, 2], [3, 4]], [[5, 6], [7, 8]]] }

    context 'when flatten option is true' do
      let(:options_hash) do
        { flatten: true, key: :value }
      end

      it 'returns the fetched value flattened' do
        expect(fetcher.fetch).to eq((1..8).to_a)
      end

      context 'when value is not an array' do
        let(:value) { 1 }

        it 'returns the fetched value flattened' do
          expect(fetcher.fetch).to eq(1)
        end
      end
    end

    context 'when flatten option is false' do
      let(:options_hash) do
        { flatten: false, key: :value }
      end

      it 'returns the fetched value non flattened' do
        expect(fetcher.fetch).to eq(value)
      end
    end
  end

  describe 'after option' do
    let(:instance) { MyParser.new(json) }
    let(:json)     { { value: [100, 250, -25] } }

    let(:options_hash) do
      { after: :sum, key: :value }
    end

    it 'applies after call ' do
      expect(fetcher.fetch).to eq(325)
    end
  end

  describe 'klass options' do
    let(:path)    { 'name' }
    let(:name)    { 'Robert' }
    let(:json)    { { name: name } }
    let(:wrapper) { Person }

    let(:options_hash) do
      { klass: wrapper, path: path }
    end

    it 'wraps the result in an object' do
      expect(fetcher.fetch).to be_a(wrapper)
    end

    it 'sets the wrapper with the fetched value' do
      expect(fetcher.fetch.name).to eq(name)
    end
  end

  describe 'after_each options' do
    let(:full_path) { 'people.name' }
    let(:instance)  { Group.new(json) }

    let(:options_hash) do
      {
        full_path:  full_path,
        after_each: :create_person,
        json:       :@hash,
        compact:    true
      }
    end

    let(:json) do
      {
        people: [
          { name: 'Robert', age: 20 },
          { name: 'John',   age: 25 },
          { name: 'Leeloo', age: 3570 },
          { age: 10 }
        ]
      }
    end

    it do
      expect(fetcher.fetch).to be_a(Array)
    end

    it 'calls the given method on each value' do
      expect(fetcher.fetch).to all(be_a(Person))
    end
  end

  describe 'json options' do
    context 'when json is a method' do
      let(:instance)     { described_class::HashJson.new(hash) }
      let(:hash)         { { name: 'John Doe' } }
      let(:options_hash) { { key: :name, json: :hash } }

      it 'fetches hash from given method' do
        expect(fetcher.fetch).to eq('John Doe')
      end
    end

    context 'when json is an instance variable' do
      let(:instance)     { described_class::NoAccessor.new(hash) }
      let(:hash)         { { name: 'John Doe' } }
      let(:options_hash) { { key: :name, json: :@hash } }

      it 'fetches hash from given method' do
        expect(fetcher.fetch).to eq('John Doe')
      end
    end

    context 'when json is an instance variable' do
      let(:instance)     { described_class::ClassVariable.new }
      let(:hash)         { { name: 'John Doe' } }
      let(:options_hash) { { key: :name, json: :@@json } }

      before do
        described_class::ClassVariable.json = hash
      end

      it 'fetches hash from given method' do
        expect(fetcher.fetch).to eq('John Doe')
      end
    end
  end
end
