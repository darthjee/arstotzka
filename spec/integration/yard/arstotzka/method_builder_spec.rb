# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::MethodBuilder do
  xdescribe 'yard' do
    subject(:builder) { described_class.new(attributes, klass, options) }

    let!(:instance) { klass.new(hash) }
    let(:options)   { Arstotzka.config.options(options_hash) }
    let(:hash) do
      {
        'name' => { first: 'John', last: 'Williams' },
        :age => '20',
        'cars' => 2.0
      }
    end

    describe '#first_name' do
      let(:klass)        { Class.new(MyModel) }
      let(:attributes)   { [:first_name] }
      let(:options_hash) { { full_path: 'name.first' } }

      before do
        builder.build
      end

      it 'crawls into the hash to find the value of the first name' do
        expect(instance.first_name).to eq('John')
      end
    end

    describe '#age' do
      let(:klass)        { Class.new(MyModel) }
      let(:attributes)   { %i[age cars] }
      let(:options_hash) { { type: :integer } }

      before do
        builder.build
      end

      it 'crawls into the hash to find the value of the age' do
        expect(instance.age).to eq(20)
      end

      it do
        expect(instance.age).to be_a(Integer)
      end
    end

    describe '#cars' do
      let(:klass)        { Class.new(MyModel) }
      let(:attributes)   { %i[age cars] }
      let(:options_hash) { { type: :integer } }

      before do
        builder.build
      end

      it 'crawls into the hash to find the value of the age' do
        expect(instance.cars).to eq(2)
      end

      it do
        expect(instance.cars).to be_a(Integer)
      end
    end
  end
end
