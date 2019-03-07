# frozen_string_literal: true

describe Arstotzka::Options do
  subject(:options) { described_class.new(options_hash) }

  context 'when initializing without options' do
    let(:options_hash) { {} }

    describe '#json' do
      it 'returns default json option' do
        expect(subject.json).to eq(:json)
      end
    end

    describe '#full_path' do
      it do
        expect(subject.full_path).to be_nil
      end
    end

    describe '#cached' do
      it do
        expect(subject.cached).to be_falsey
      end
    end

    describe '#after' do
      it do
        expect(subject.after).to be_falsey
      end
    end

    describe '#case' do
      it do
        expect(subject.case).to eq(:lower_camel)
      end
    end

    describe '#compact' do
      it do
        expect(subject.case).to be_falsey
      end
    end

    describe '#default' do
      it do
        expect(subject.case).to be_nil
      end
    end

    describe '#type' do
      it do
        expect(subject.case).to eq(:none)
      end
    end
  end
end
