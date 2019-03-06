# frozen_string_literal: truie

describe Arstotzka::Wrapper do
  subject(:wrapper) { described_class.new(clazz: clazz, type: type) }

  let(:type)  { nil }
  let(:clazz) { nil }

  describe 'yard' do
    describe '#wrap' do
      context 'when clazz is defined' do
        let(:clazz) { Person }

        it 'wraps value with the clazz' do
          expect(subject.wrap('john')).to be_a(Person)
          expect(subject.wrap('john').name).to eq('john')
        end
      end

      context 'when type is defined' do
        let(:type) { :integer }

        it 'converts value to type' do
          expect(subject.wrap(%w[10 20 30])).to eq([10, 20, 30])
        end
      end
    end
  end
end
