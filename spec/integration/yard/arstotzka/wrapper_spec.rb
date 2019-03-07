# frozen_string_literal: truie

describe Arstotzka::Wrapper do
  subject(:wrapper) { described_class.new(clazz: clazz, type: type) }

  let(:type)  { nil }
  let(:clazz) { nil }

  describe 'yard' do
    describe '#wrap' do
      context 'when clazz is defined' do
        let(:clazz) { Person }
        let(:value) { 'john' }

        it 'wraps value with the clazz' do
          expect(wrapper.wrap(value)).to eq(Person.new(value))
        end
      end

      context 'when type is defined' do
        let(:type)  { :integer }
        let(:value) { %w[10 20 30] }

        it 'converts value to type' do
          expect(wrapper.wrap(value)).to eq([10, 20, 30])
        end
      end

      context 'when type and class is defined' do
        let(:type)    { :string }
        let(:clazz)   { Request }
        let(:value)   { { 'key' => 'value' } }
        let(:request) { wrapper.wrap(value) }

        it 'returns a wrapped object' do
          expect(request).to be_a(Request)
        end

        it 'casts before wrapping' do
          expect(request.payload).to eq('{"key"=>"value"}')
        end
      end
    end
  end
end
