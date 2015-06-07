require 'spec_helper'

describe JsonParser::PostProcessor do
  let(:options) { {} }
  let(:subject) { described_class.new options }
  let(:hash) { { a: 1 } }

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

    context 'with type otpion' do
      let(:value) { '1' }
      let(:options) { { type: type } }

      context 'with integer type' do
        let(:type) { :integer }

        it do
          expect(result).to be_a(Integer)
        end
      end

      context 'with float type' do
        let(:type) { :float }

        it do
          expect(result).to be_a(Float)
        end
      end

      context 'with string type' do
        let(:value) { 1 }
        let(:type) { :string }

        it do
          expect(result).to be_a(String)
        end
      end
    end
  end
end
