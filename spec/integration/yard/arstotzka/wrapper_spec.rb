require 'spec_helper'

describe Arstotzka::Wrapper do
  describe 'yard' do
    describe '#wrap' do
      subject { described_class.new(clazz: clazz, type: type) }
      let(:clazz) { nil }
      let(:type) { nil }


      context 'when definning clazz' do
        let(:clazz) { Person }

        it 'returns the valued wrapped in a class' do
          expect(subject.wrap('John')).to eq(Person.new('John'))
        end
      end

      context 'when defing type' do
        let(:type) { :integer }

        it 'casts all values' do
          expect(subject.wrap(['10', '20', '30'])).to eq([10, 20, 30])
        end
      end
    end
  end
end
