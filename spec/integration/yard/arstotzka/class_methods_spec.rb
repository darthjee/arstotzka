# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::ClassMethods do
  describe 'yard' do
    let!(:instance) { klass.new(hash) }
    let(:klass) do
      Class.new(MyModel) do
        include Arstotzka
        expose :first_name, full_path: 'name.first'
        expose :age, 'cars', type: :integer
      end
    end
    let(:hash) do
      {
        'name' => { first: 'John', last: 'Williams' },
        :age => '20',
        'cars' => 2.0
      }
    end

    describe '#first_name' do
      it 'crawls into the hash to find the value of the first name' do
        expect(instance.first_name).to eq('John')
      end
    end

    describe '#age' do
      it 'crawls into the hash to find the value of the age' do
        expect(instance.age).to eq(20)
      end

      it do
        expect(instance.age).to be_a(Integer)
      end
    end

    describe '#cars' do
      it 'crawls into the hash to find the value of the age' do
        expect(instance.cars).to eq(2)
      end

      it do
        expect(instance.cars).to be_a(Integer)
      end
    end
  end
end
