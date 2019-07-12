# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::PostProcessor do
  describe 'yard' do
    subject(:processor) { described_class.new(options) }

    let(:company) { Company.new }

    let(:options) do
      {
        after: :create_employes,
        flatten: true,
        instance: company
      }
    end

    let(:value) do
      [
        [
          { name: 'Bob',   age: 21 },
          { name: 'Rose',  age: 19 }
        ], [
          { name: 'Klara', age: 18 },
          { name: 'Al',    age: 15 }
        ]
      ]
    end

    let(:expected) do
      [
        Employe.new(name: 'Bob',   age: 21, company: company),
        Employe.new(name: 'Rose',  age: 19, company: company),
        Employe.new(name: 'Klara', age: 18, company: company)
      ]
    end

    describe 'Simple usage' do
      it 'maps and filter' do
        expect(processor.process(value)).to eq(expected)
      end
    end
  end
end
