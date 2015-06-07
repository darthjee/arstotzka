require 'spec_helper'

describe JsonParser::PostProcessor do
  let(:options) { {} }
  let(:subject) { described_class.new options }
  let(:hash) { { a: 1} }

  describe '#wrap' do
    let(:value) { hash }
    let(:result) { subject.wrap(value) }

    context 'with default options' do
      it 'does not change the json value' do
        expect(result).to eq(value)
      end

      context 'with an array as value' do
        let(:value) { [hash] }

        it 'does not change the array' do
          expect(result).to eq(value)
        end
      end
    end

    context 'with clazz otpion' do
      let(:options) { { clazz: OpenStruct } }

      it 'creates new instance from given class' do
        expect(result).to be_a(OpenStruct)
        expect(result.a).to eq(hash[:a])
      end

      context 'with an array as value' do
        let(:value) { [hash] }

        it 'returns an array of objects of the given class' do
          expect(result).to be_a(Array)
          expect(result.first).to be_a(OpenStruct)
        end
      end
    end
  end
end
