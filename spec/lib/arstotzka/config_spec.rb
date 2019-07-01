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

  describe '#full_path' do
    it do
      expect(config.full_path).to be_nil
    end

    context 'when configuring value' do
      before { Arstotzka.configure { full_path 'path.key' } }

      it 'returns configured value' do
        expect(config.full_path).to eq('path.key')
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

  describe '#path' do
    it do
      expect(config.path).to be_nil
    end

    context 'when configuring value' do
      before { Arstotzka.configure { path 'path' } }

      it 'returns configured value' do
        expect(config.path).to eq('path')
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
