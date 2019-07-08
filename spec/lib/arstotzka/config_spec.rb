# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Config do
  subject(:config) { Arstotzka.config }

  after do
    Arstotzka.reset_config
  end

  describe '#options' do
    it do
      expect(config.options).to be_a(Arstotzka::Options)
    end

    it 'generates options with default values' do
      expect(config.options.to_h)
        .to eq(
          described_class::DEFAULT_CONFIGS.merge(
            path: nil, full_path: nil
          )
        )
    end

    context 'when configuring it' do
      let(:expected_options_hash) do
        {
          after:      :method,
          after_each: :each_method,
          cached:     true,
          case:       :snake,
          compact:    true,
          default:    10,
          flatten:    true,
          json:       :@hash,
          klass:      Account,
          type:       :string,
          path:       nil,
          full_path:  nil
        }
      end

      before do
        Arstotzka.configure do |c|
          after      :method
          after_each :each_method
          cached     true
          c.case     :snake
          compact    true
          default    10
          flatten    true
          json       :@hash
          klass      Account
          type       :string
        end
      end

      it 'generates options with given values' do
        expect(config.options.to_h)
          .to eq(expected_options_hash)
      end
    end

    context 'when passing a hash' do
      let(:options_hash) do
        expected_options_hash
      end

      let(:expected_options_hash) do
        {
          after:      :method,
          after_each: :each_method,
          cached:     true,
          case:       :snake,
          compact:    true,
          default:    10,
          flatten:    true,
          json:       :@hash,
          klass:      Account,
          type:       :string,
          path:       nil,
          full_path:  nil
        }
      end

      it 'generates options with given values' do
        expect(config.options(options_hash).to_h)
          .to eq(expected_options_hash)
      end
    end
  end

  describe '#after' do
    it do
      expect(config.after).to be_falsey
    end

    context 'when configuring value' do
      before { Arstotzka.configure { after :method } }

      it 'returns configured value' do
        expect(config.after).to eq(:method)
      end
    end
  end

  describe '#after_each' do
    it do
      expect(config.after).to be_falsey
    end

    context 'when configuring value' do
      before { Arstotzka.configure { after_each :each_method } }

      it 'returns configured value' do
        expect(config.after_each).to eq(:each_method)
      end
    end
  end

  describe '#cached' do
    it do
      expect(config.cached).to be_falsey
    end

    context 'when configuring value' do
      before { Arstotzka.configure { cached true } }

      it 'returns configured value' do
        expect(config.cached).to be_truthy
      end
    end
  end

  describe '#case' do
    it 'returns default case' do
      expect(config.case).to eq(:lower_camel)
    end

    context 'when configuring value' do
      before { Arstotzka.configure { |c| c.case :snake } }

      it 'returns configured value' do
        expect(config.case).to eq(:snake)
      end
    end
  end

  describe '#compact' do
    it do
      expect(config.compact).to be_falsey
    end

    context 'when configuring value' do
      before { Arstotzka.configure { compact true } }

      it 'returns configured value' do
        expect(config.case).to be_truthy
      end
    end
  end

  describe '#default' do
    it do
      expect(config.default).to be_nil
    end

    context 'when configuring value' do
      before { Arstotzka.configure { default 10 } }

      it 'returns configured value' do
        expect(config.default).to eq(10)
      end
    end
  end

  describe '#flatten' do
    it do
      expect(config.flatten).to be_falsey
    end

    context 'when configuring value' do
      before { Arstotzka.configure { flatten true } }

      it 'returns configured value' do
        expect(config.flatten).to be_truthy
      end
    end
  end

  describe '#json' do
    it 'returns default json option' do
      expect(config.json).to eq(:json)
    end

    context 'when configuring value' do
      before { Arstotzka.configure { json :@hash } }

      it 'returns configured value' do
        expect(config.json).to eq(:@hash)
      end
    end
  end

  describe '#klass' do
    it do
      expect(config.klass).to be_nil
    end

    context 'when configuring value' do
      before { Arstotzka.configure { klass Account } }

      it 'returns configured value' do
        expect(config.klass).to eq(Account)
      end
    end
  end

  describe '#type' do
    it 'returns none' do
      expect(config.type).to eq(:none)
    end

    context 'when configuring value' do
      before { Arstotzka.configure { type :string } }

      it 'returns configured value' do
        expect(config.type).to eq(:string)
      end
    end
  end
end
