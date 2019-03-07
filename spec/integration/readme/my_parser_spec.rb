# frozen_string_literal: true

require 'spec_helper'

describe MyParser do
  subject(:parser) { described_class.new(hash) }

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
      expect(parser.id).to eq(10)
    end
  end

  describe 'name' do
    it 'returns the parsed name' do
      expect(parser.name).to eq('Robert')
    end

    context 'when person is missing' do
      subject(:parser) { described_class.new }

      it do
        expect { parser.name }.not_to raise_error
      end

      it do
        expect(parser.name).to be_nil
      end
    end
  end

  describe 'age' do
    it do
      expect(parser.age).to be_a(Integer)
    end

    it 'returns the parsed age' do
      expect(parser.age).to eq(22)
    end
  end

  describe '#total_money' do
    it do
      expect(parser.total_money).to be_a(Float)
    end

    it 'summs all the balance in the accounts' do
      expect(parser.total_money).to eq(1050.36)
    end

    context 'when there is a node missing' do
      let(:hash) { {} }

      it 'returns nil' do
        expect(parser.total_money).to be_nil
      end
    end
  end

  describe '#total_owed' do
    it do
      expect(parser.total_owed).to be_a(Float)
    end

    it 'summs all the balance in the accounts' do
      expect(parser.total_owed).to eq(550.84)
    end
  end
end
