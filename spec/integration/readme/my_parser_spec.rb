require 'spec_helper'

describe MyParser do
  subject { described_class.new(hash) }

  let(:hash) do
    {
      id: 10,
      person: {
        name: 'Robert',
        age: 22
      },
      accounts: [
        { balance: '$ 1000.50', type: 'checking' },
        { balance: '$ 150.10', type: 'savings' },
        { balance: '$ -100.24', type: 'checking' }
      ],
      loans: [
        { value: '$ 300.50', bank: 'the_bank' },
        { value: '$ 150.10', type: 'the_other_bank' },
        { value: '$ 100.24', type: 'the_same_bank' }
      ]
    }
  end

  describe 'id' do
    it 'returns the parsed id' do
      expect(subject.id).to eq(10)
    end
  end

  describe 'name' do
    it 'returns the parsed name' do
      expect(subject.name).to eq('Robert')
    end

    context 'when person is missing' do
      subject { described_class.new }

      it do
        expect { subject.name }.not_to raise_error
      end

      it do
        expect(subject.name).to be_nil
      end
    end
  end

  describe 'age' do
    it do
      expect(subject.age).to be_a(Integer)
    end

    it 'returns the parsed age' do
      expect(subject.age).to eq(22)
    end
  end

  describe '#total_money' do
    it do
      expect(subject.total_money).to be_a(Float)
    end

    it 'summs all the balance in the accounts' do
      expect(subject.total_money).to eq(1050.36)
    end

    context 'when there is a node missing' do
      let(:hash) { {} }
      it 'returns nil' do
        expect(subject.total_money).to be_nil
      end
    end
  end

  describe '#total_owed' do
    it do
      expect(subject.total_owed).to be_a(Float)
    end

    it 'summs all the balance in the accounts' do
      expect(subject.total_owed).to eq(550.84)
    end
  end
end
