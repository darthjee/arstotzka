# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Crawler do
  subject(:crawler) do
    described_class.new default_options.merge(options), &block
  end

  let(:block)           { proc { |v| v } }
  let(:keys)            { [] }
  let(:full_path)       { keys.join('.') }
  let(:default_options) { { full_path: full_path, case: :lower_camel } }
  let(:options)         { {} }
  let(:json_file)       { 'arstotzka.json' }
  let(:json)            { load_json_fixture_file(json_file) }
  let(:value)           { crawler.value(json) }

  context 'when no block is given' do
    subject(:crawler) do
      described_class.new default_options.merge(options)
    end

    let(:keys) { %w[user name] }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['user']['name'])
    end
  end

  context 'when parsing with a keys' do
    let(:keys) { %w[user name] }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['user']['name'])
    end

    context 'when calling twice' do
      before { crawler.value(json) }

      it 'can still crawl' do
        expect(value).to eq(json['user']['name'])
      end
    end
  end

  context 'when crawler finds a nil attribute' do
    let(:keys) { %w[car model] }

    it 'returns nil' do
      expect(value).to be_nil
    end

    it do
      expect { value }.not_to raise_error
    end
  end

  context 'when there is an array of arrays' do
    let(:json_file) { 'accounts.json' }
    let(:keys)      { %w[banks accounts balance] }

    it 'returns the values as array of arrays' do
      expect(value).to eq([[1000.0, 1500.0], [50.0, -500.0]])
    end

    context 'when there is a missing node' do
      let(:json_file) { 'accounts_missing.json' }

      it 'returns the missing values as nil' do
        expect(value).to eq([[1000.0, nil, nil], nil, nil])
      end

      context 'when setting a default' do
        let(:options) { { default: 10 } }

        it 'returns the missing values as default' do
          expect(value).to eq([[1000.0, 10, nil], 10, 10])
        end
      end

      context 'when setting compact' do
        let(:options) { { compact: true } }

        it 'returns the missing values as nil' do
          expect(value).to eq([[1000.0]])
        end
      end
    end
  end

  context 'when json is empty' do
    let(:json) { nil }
    let(:keys) { %w[car model] }

    it 'returns nil' do
      expect(value).to be_nil
    end

    it do
      expect { value }.not_to raise_error
    end
  end

  context 'with an snake case keys' do
    let(:keys) { ['has_money'] }

    it 'returns camel cased value' do
      expect(value).to eq(json['hasMoney'])
    end
  end

  context 'when dealing with json inside arrays' do
    let(:keys) { %w[animals race species name] }
    let(:expected) do
      ['European squid', 'Macaque monkey', 'Mexican redknee tarantula']
    end

    it do
      expect(value).to be_a(Array)
    end

    it 'parses them mapping arrays as sub parse' do
      expect(value).to eq(expected)
    end

    context 'when there are nil values' do
      context 'with compact option as false' do
        let(:options) { { compact: false } }

        let(:expected) do
          ['European squid', 'Macaque monkey', nil]
        end

        before do
          json['animals'].last['race'] = nil
        end

        it 'eliminate nil values' do
          expect(value).to eq(expected)
        end
      end

      context 'with compact option' do
        let(:options) { { compact: true } }

        let(:expected) do
          ['European squid', 'Macaque monkey']
        end

        before do
          json['animals'].last['race'] = nil
        end

        it 'eliminate nil values' do
          expect(value).to eq(expected)
        end
      end
    end
  end

  context 'with default option' do
    let(:default_value) { 'NotFound' }
    let(:options) { { default: default_value } }
    let(:keys)    { %w[projects name] }

    context 'when there is a key missing' do
      it 'returns the default value' do
        expect(value).to eq(default_value)
      end

      context 'when wrapping it with a class' do
        let(:block) { proc { |v| Person.new(v) } }

        it 'wrap it with the class' do
          expect(value).to be_a(Person)
        end

        it 'wraps the default value' do
          expect(value.name).to eq(default_value)
        end
      end
    end

    context 'when the key is not missing but the value is nil' do
      let(:json_file) { 'person.json' }
      let(:keys)      { %w[user name] }

      it { expect(value).to be_nil }

      context 'when wrapping it with a class' do
        let(:block) { proc { |v| Person.new(v) } }

        it 'wrap it with the class' do
          expect(value).to be_a(Person)
        end

        it 'wraps the default value' do
          expect(value.name).to be_nil
        end
      end
    end

    context 'when the key last key is missing but the value is nil' do
      let(:json_file) { 'person.json' }
      let(:keys)      { %w[user nick_name] }

      it 'returns the default value' do
        expect(value).to eq(default_value)
      end

      context 'when wrapping it with a class' do
        let(:block) { proc { |v| Person.new(v) } }

        it 'wrap it with the class' do
          expect(value).to be_a(Person)
        end

        it 'wraps the default value' do
          expect(value.name).to eq(default_value)
        end
      end
    end

    context 'when the node is missing but default has the same node' do
      let(:default_value) { { node: { value: 1 } } }
      let(:keys)          { %w[node node node] }
      let(:json)          { {} }

      it 'does not crawl through default value' do
        expect(value).to eq(default_value)
      end
    end
  end

  context 'when using a snake case' do
    let(:json) { { snake_cased: 'snake', snakeCased: 'Camel' }.stringify_keys }
    let(:keys)    { ['snake_cased'] }
    let(:options) { { case: :snake } }

    it 'fetches from snake cased fields' do
      expect(value).to eq('snake')
    end
  end

  context 'when using a upper camel case' do
    let(:json) { { UpperCase: 'upper', upperCase: 'lower' }.stringify_keys }
    let(:keys)    { ['upper_case'] }
    let(:options) { { case: :upper_camel } }

    it 'fetches from upper camel cased fields' do
      expect(value).to eq('upper')
    end
  end

  context 'when using a symbol keys' do
    let(:json) { load_json_fixture_file('arstotzka.json').symbolize_keys }
    let(:keys) { ['id'] }

    it 'fetches from symbol keys' do
      expect(value).to eq(json[:id])
    end

    context 'when crawler finds a nil attribute' do
      let(:keys) { %w[car model] }

      it 'returns nil' do
        expect(value).to be_nil
      end

      it do
        expect { value }.not_to raise_error
      end
    end
  end

  context 'when using key with false value' do
    let(:keys) { ['has_money'] }

    before do
      json['hasMoney'] = false
    end

    context 'with string keys' do
      it { expect(value).to be_falsey }
      it { expect(value).not_to be_nil }
    end

    context 'with symbol keys' do
      before do
        json.symbolize_keys!
      end

      it { expect(value).to be_falsey }
      it { expect(value).not_to be_nil }
    end
  end
end
