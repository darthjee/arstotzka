# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Fetcher do
  describe 'yard' do
    describe '#fetch' do
      subject(:fetcher) { described_class.new(nil, instance, **options) }

      let(:instance) { Account.new(hash) }
      let(:options) do
        {
          path:  'transactions',
          klass: Transaction,
          after: :filter_income
        }
      end
      let(:hash) do
        {
          transactions: [
            { value: 1000.53, type: 'income' },
            { value: 324.56,  type: 'outcome' },
            { value: 50.23,   type: 'income' },
            { value: 150.00,  type: 'outcome' },
            { value: 10.23,   type: 'outcome' },
            { value: 100.12,  type: 'outcome' },
            { value: 101.00,  type: 'outcome' }
          ]
        }
      end

      describe 'incoming transactions' do
        it 'returns only the income payments' do
          expect(fetcher.fetch.count).to eq(2)
        end

        it 'returns Transactions' do
          expect(fetcher.fetch.map(&:class).uniq).to eq([Transaction])
        end

        it 'returns results wrapped in Transactions' do
          expected = [
            Transaction.new(value: 1000.53, type: 'income'),
            Transaction.new(value: 50.23, type: 'income')
          ]
          expect(fetcher.fetch).to eq(expected)
        end
      end
    end
  end
end
