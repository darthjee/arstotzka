# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Options do
  subject(:options) { Arstotzka.config.options(options_hash) }

  context 'when initializing without options' do
    let(:options_hash) { {} }

    describe '#after' do
      it do
        expect(options.after).to be_falsey
      end
    end

    describe '#cached' do
      it do
        expect(options.cached).to be_falsey
      end
    end

    describe '#case' do
      it 'returns default case' do
        expect(options.case).to eq(:lower_camel)
      end
    end

    describe '#compact' do
      it do
        expect(options.compact).to be_falsey
      end
    end

    describe '#default' do
      it do
        expect(options.default).to be_nil
      end
    end

    describe '#flatten' do
      it do
        expect(options.flatten).to be_falsey
      end
    end

    describe '#full_path' do
      it do
        expect(options.full_path).to be_nil
      end
    end

    describe '#json' do
      it 'returns default json option' do
        expect(options.json).to eq(:json)
      end
    end

    describe '#klass' do
      it do
        expect(options.klass).to be_nil
      end
    end

    describe '#path' do
      it do
        expect(options.path).to be_nil
      end
    end

    describe '#type' do
      it 'returns none' do
        expect(options.type).to eq(:none)
      end
    end
  end

  context 'when initializing with options' do
    let(:options_hash) do
      {
        after:     :method_call,
        cached:    true,
        case:      :snake,
        compact:   true,
        default:   10,
        flatten:   true,
        full_path: 'key.sub.fetch',
        json:      :hash,
        klass:     Star,
        path:      'key.sub',
        type:      :integer
      }
    end

    describe '#cached' do
      it do
        expect(options.cached).to be_truthy
      end
    end

    describe '#after' do
      it 'returns method name' do
        expect(options.after).to eq(:method_call)
      end
    end

    describe '#case' do
      it 'returns defined snake case' do
        expect(options.case).to eq(:snake)
      end
    end

    describe '#compact' do
      it do
        expect(options.compact).to be_truthy
      end
    end

    describe '#default' do
      it 'returns defined default value' do
        expect(options.default).to eq(10)
      end
    end

    describe '#flatten' do
      it do
        expect(options.flatten).to be_truthy
      end
    end

    describe '#full_path' do
      it 'returns defined full path' do
        expect(options.full_path).to eq('key.sub.fetch')
      end
    end

    describe '#json' do
      it 'returns defined json option' do
        expect(options.json).to eq(:hash)
      end
    end

    describe '#klass' do
      it 'returns defined class' do
        expect(options.klass).to eq(Star)
      end
    end

    describe '#path' do
      it 'returns defined path' do
        expect(options.path).to eq('key.sub')
      end
    end

    describe '#type' do
      it 'returns defined path' do
        expect(options.type).to eq(:integer)
      end
    end
  end

  describe '#klass' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:warn)
    end

    context 'when initializing with old class key' do
      let(:options_hash) { { class: Star } }

      it 'returns the configured class' do
        expect(options.klass).to eq(Star)
      end

      it 'raises a warn' do
        expect(options).to have_received(:warn)
      end
    end

    context 'when initializing with old class key and klass' do
      let(:options_hash) { { class: Star, klass: Game } }

      it 'returns the configured class' do
        expect(options.klass).to eq(Game)
      end

      it 'raises a warn' do
        expect(options).to have_received(:warn)
      end
    end
  end

  describe '#merge' do
    let(:options_hash) { { json: :hash, default: 10 } }

    it do
      expect(options.merge(default: 10)).to be_a(described_class)
    end

    it 'overrides values' do
      expect(options.merge(default: 10).default).to eq(10)
    end

    it 'keeps not overriten value' do
      expect(options.merge(default: 10).json).to eq(:hash)
    end
  end

  describe '#keys' do
    let(:options_hash) { { path: path, key: key, full_path: full_path } }
    let(:key)          { :id }
    let(:path)         { nil }
    let(:full_path)    { nil }

    context 'when full_path is nil' do
      context 'when path is nil' do
        it 'returns only the key' do
          expect(options.keys).to eq(['id'])
        end
      end

      context 'when path is empty' do
        let(:path) { '' }

        it 'returns only the key' do
          expect(options.keys).to eq(['id'])
        end
      end

      context 'when path is not empty' do
        let(:path) { 'account.person' }

        it 'returns the path splitted and the key' do
          expect(options.keys).to eq(%w[account person id])
        end
      end
    end

    context 'when full_path is empty' do
      let(:full_path) { '' }

      context 'when path is nil' do
        it 'returns empty array' do
          expect(options.keys).to eq([])
        end
      end

      context 'when path is empty' do
        let(:path) { '' }

        it 'returns empty array' do
          expect(options.keys).to eq([])
        end
      end

      context 'when path is not empty' do
        let(:path) { 'account.person' }

        it 'returns empty array' do
          expect(options.keys).to eq([])
        end
      end
    end

    context 'when full_path is not empty' do
      let(:full_path) { 'account.person_id' }

      context 'when path is nil' do
        it 'returns splitted full path' do
          expect(options.keys).to eq(%w[account person_id])
        end
      end

      context 'when path is empty' do
        let(:path) { '' }

        it 'returns splitted full path' do
          expect(options.keys).to eq(%w[account person_id])
        end
      end

      context 'when path is not empty' do
        let(:path) { 'account.person' }

        it 'returns splitted full path' do
          expect(options.keys).to eq(%w[account person_id])
        end
      end
    end
  end
end
