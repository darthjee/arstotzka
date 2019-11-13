# frozen_string_literal: true

describe Arstotzka::TypeCast do
  subject(:caster) do
    Class.new do
      extend Arstotzka::TypeCast
    end
  end

  describe '.to_integer' do
    context 'when value is nil' do
      let(:value) {}

      it { expect(caster.to_integer(value)).to be_nil }
    end

    context 'when value is an integer' do
      let(:value) { 10 }

      it 'returns the value' do
        expect(caster.to_integer(value)).to eq(value)
      end

      it { expect(caster.to_integer(value)).to be_a(Integer) }
    end

    context 'when value is a string' do
      let(:value) { '10' }

      it 'returns integer' do
        expect(caster.to_integer(value)).to eq(10)
      end

      it { expect(caster.to_integer(value)).to be_a(Integer) }
    end

    context 'when value is an empty string' do
      let(:value) { '' }

      it { expect(caster.to_integer(value)).to be_nil }
    end

    context 'when value is an invalid string' do
      let(:value) { 'abc' }

      it { expect(caster.to_integer(value)).to eq(0) }

      it { expect(caster.to_integer(value)).to be_a(Integer) }
    end

    context 'when value is a symbol' do
      let(:value) { :'10' }

      it 'returns integer' do
        expect(caster.to_integer(value)).to eq(10)
      end

      it { expect(caster.to_integer(value)).to be_a(Integer) }
    end

    context 'when value is a float' do
      let(:value) { 10.7 }

      it 'returns integer rounded down' do
        expect(caster.to_integer(value)).to eq(10)
      end

      it { expect(caster.to_integer(value)).to be_a(Integer) }
    end
  end

  describe '.to_string' do
    context 'when value is nil' do
      let(:value) {}

      it { expect(caster.to_string(value)).to eq('') }
    end

    context 'when value is a string' do
      let(:value) { 'a' }

      it 'returns value itself' do
        expect(caster.to_string(value)).to eq(value)
      end
    end

    context 'when value is a symbol' do
      let(:value) { :a }

      it 'returns converted string' do
        expect(caster.to_string(value)).to eq('a')
      end
    end

    context 'when value an integer' do
      let(:value) { 10 }

      it 'returns converted string' do
        expect(caster.to_string(value)).to eq('10')
      end
    end

    context 'when value a float' do
      let(:value) { 10.5 }

      it 'returns converted string' do
        expect(caster.to_string(value)).to eq('10.5')
      end
    end
  end

  describe '.to_float' do
    context 'when value is nil' do
      let(:value) {}

      it { expect(caster.to_float(value)).to be_nil }
    end

    context 'when value is an integer' do
      let(:value) { 10 }

      it 'returns float' do
        expect(caster.to_float(value)).to eq(value)
      end

      it { expect(caster.to_float(value)).to be_a(Float) }
    end

    context 'when value is a string' do
      let(:value) { '10' }

      it 'returns float' do
        expect(caster.to_float(value)).to eq(10.0)
      end

      it { expect(caster.to_float(value)).to be_a(Float) }
    end

    context 'when value is an empty string' do
      let(:value) { '' }

      it { expect(caster.to_float(value)).to be_nil }
    end

    context 'when value is an invalid string' do
      let(:value) { 'abc' }

      it { expect(caster.to_float(value)).to eq(0) }
      it { expect(caster.to_float(value)).to be_a(Float) }
    end

    context 'when value is a symbol' do
      let(:value) { :'10' }

      it 'returns float' do
        expect(caster.to_float(value)).to eq(10.0)
      end

      it { expect(caster.to_float(value)).to be_a(Float) }
    end

    context 'when value is a float' do
      let(:value) { 10.7 }

      it 'returns the value' do
        expect(caster.to_float(value)).to eq(10.7)
      end
    end
  end
end
