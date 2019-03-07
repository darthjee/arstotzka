# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Wrapper do
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
      end

      it 'uses the given value on object initialization' do
        expect(result.a).to eq(hash[:a])
      end

      context 'with an array as value' do
        let(:value) { [hash] }

        it 'returns an array' do
          expect(result).to be_a(Array)
        end

        it 'returns an array of objects of the given class' do
          expect(result).to all(be_a(OpenStruct))
        end
      end
    end

    context 'with type otpion' do
      let(:type) { :integer }
      let(:value) { '1' }
      let(:options) { { type: type } }
      let(:cast) { result }

      it_behaves_like 'casts basic types'

      context 'when processing an array' do
        let(:value) { [1.0] }
        let(:cast) { result.first }

        it_behaves_like 'casts basic types'

        it do
          expect(result).to be_a(Array)
        end
      end

      context 'with nil value' do
        let(:value) { nil }

        it do
          expect(result).to be_nil
        end

        context 'when passing clazz parameter' do
          let(:options) { { type: type, clazz: Arstotzka::Wrapper::Dummy } }

          it do
            expect(result).to be_nil
          end
        end
      end

      context 'with blank value' do
        let(:value) { '' }

        it_behaves_like 'a result that is type cast',
                        integer: NilClass,
                        float: NilClass,
                        string: String

        context 'when passing clazz parameter' do
          let(:options) { { type: type, clazz: Arstotzka::Wrapper::Dummy } }

          it_behaves_like 'a result that is type cast',
                          integer: NilClass,
                          float: NilClass,
                          string: Arstotzka::Wrapper::Dummy
        end
      end

      context 'when passing clazz parameter' do
        let(:value) { 1 }
        let(:options) { { type: type, clazz: Arstotzka::Wrapper::Dummy } }
        let(:cast) { result.value }

        it_behaves_like 'casts basic types'

        it 'wraps the result inside the given class' do
          expect(result).to be_a(Arstotzka::Wrapper::Dummy)
        end
      end

      context 'with none for type' do
        let(:type) { :none }
        let(:value) { 1.0 }

        it 'does not cast the value' do
          expect(result).to eq(value)
        end
      end
    end
  end
end
