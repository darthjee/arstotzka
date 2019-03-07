# frozen_string_literal: true

describe Arstotzka::Options do
  subject(:options) { described_class.new(options_hash) }

  context 'when initializing without options' do
    let(:options_hash) { {} }

    describe '#after' do
      it do
        expect(subject.after).to be_falsey
      end
    end

    describe '#cached' do
      it do
        expect(subject.cached).to be_falsey
      end
    end

    describe '#case' do
      it do
        expect(subject.case).to eq(:lower_camel)
      end
    end

    describe '#compact' do
      it do
        expect(subject.compact).to be_falsey
      end
    end

    describe '#default' do
      it do
        expect(subject.default).to be_nil
      end
    end

    describe '#flatten' do
      it do
        expect(subject.flatten).to be_falsey
      end
    end

    describe '#full_path' do
      it do
        expect(subject.full_path).to be_nil
      end
    end

    describe '#json' do
      it 'returns default json option' do
        expect(subject.json).to eq(:json)
      end
    end

    describe '#path' do
      it do
        expect(subject.path).to be_nil
      end
    end

    describe '#type' do
      it do
        expect(subject.type).to eq(:none)
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
        path:      'key.sub',
        type:      :integer,
      }
    end

    describe '#cached' do
      it do
        expect(subject.cached).to be_truthy
      end
    end

    describe '#after' do
      it do
        expect(subject.after).to eq(:method_call)
      end
    end

    describe '#case' do
      it do
        expect(subject.case).to eq(:snake)
      end
    end

    describe '#compact' do
      it do
        expect(subject.compact).to be_truthy
      end
    end

    describe '#default' do
      it do
        expect(subject.default).to eq(10)
      end
    end

    describe '#flatten' do
      it do
        expect(subject.flatten).to be_truthy
      end
    end

    describe '#full_path' do
      it do
        expect(subject.full_path).to eq('key.sub.fetch')
      end
    end

    describe '#json' do
      it 'returns default json option' do
        expect(subject.json).to eq(:hash)
      end
    end

    describe '#path' do
      it do
        expect(subject.path).to eq('key.sub')
      end
    end

    describe '#type' do
      it do
        expect(subject.type).to eq(:integer)
      end
    end
  end
end
