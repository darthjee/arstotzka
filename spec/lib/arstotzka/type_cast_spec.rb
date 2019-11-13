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

      it "returns the value" do
        expect(caster.to_integer(value)).to eq(value)
      end
    end

    context 'when value is a string' do
      let(:value) { '10' }

      it "returns integer" do
        expect(caster.to_integer(value)).to eq(10)
      end
    end

    context 'when value is an empty string' do
      let(:value) { '' }

      it { expect(caster.to_integer(value)).to be_nil }
    end

    context 'when value is an invalid string' do
      let(:value) { 'abc' }

      it { expect(caster.to_integer(value)).to eq(0) }
    end

    context 'when value is a symbol' do
      let(:value) { :'10' }

      it "returns integer" do
        expect(caster.to_integer(value)).to eq(10)
      end
    end

    context 'when value is a float' do
      let(:value) { 10.7 }

      it "returns integer rounded down" do
        expect(caster.to_integer(value)).to eq(10)
      end
    end
  end
end
