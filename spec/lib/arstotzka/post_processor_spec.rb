# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::PostProcessor do
  subject(:processor) { described_class.new(options) }

  let(:options) { {} }
  let(:value)   { [%w[Bob Klara], %w[Rose Aria]] }

  describe '#process' do
    context 'when no options are given' do
      it 'returns the value with no change' do
        expect(processor.process(value)).to eq(value)
      end
    end

    context 'when passing flatten option' do
      let(:options) { { flatten: true } }

      it 'flattens the array' do
        expect(processor.process(value))
          .to eq(%w[Bob Klara Rose Aria])
      end
    end

    context 'when passing after' do
      let(:company) { Company.new }

      let(:options) do
        { after: :create_employes, instance: company }
      end

      let(:value) do
        [
          { name: 'Bob',   age: 21 },
          { name: 'Klara', age: 18 },
          { name: 'Rose',  age: 16 },
          { name: 'Al',    age: 15 }
        ]
      end

      let(:expected) do
        [
          Employe.new(name: 'Bob',   age: 21, company: company),
          Employe.new(name: 'Klara', age: 18, company: company)
        ]
      end

      it 'maps and filtes by method' do
        expect(processor.process(value)).to eq(expected)
      end
    end
  end
end
