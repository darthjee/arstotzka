# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Options do
  subject(:instance) { clazz.new(hash) }

  describe 'yard' do
    describe 'Using options klass and after' do
      let(:hash) do
        {
          customers: [{
            name: 'John', age: 21
          }, {
            name: 'Julia', age: 15
          }, {
            name: 'Carol', age: 22
          }, {
            name: 'Bobby', age: 12
          }]
        }
      end

      let(:clazz) { Store }
      let(:expected) do
        [
          Customer.new(name: 'John',  age: 21),
          Customer.new(name: 'Carol', age: 22)
        ]
      end

      it 'returns only the adults' do
        expect(instance.customers).to eq(expected)
      end
    end

    describe 'type with klass and after_each' do
      let(:clazz) { Bar }
      let(:hash)  { JSON.parse(json) }

      let(:json) do
        '{"drinks":[{"name":"tequila","price":7.50},{ "name":"vodka","price":5.50}]}'
      end

      let(:expected) do
        [
          Drink.new(name: 'tequila', price: 8.25),
          Drink.new(name: 'vodka',   price: 6.05)
        ]
      end

      before do
        module Arstotzka::TypeCast
          def to_symbolized_hash(value)
            value.symbolize_keys
          end
        end
      end

      it 'returns inflated drinks' do
        expect(instance.drinks).to eq(expected)
      end
    end

    describe 'Using cached, compact, after and full_path' do
      let(:clazz) { Application }

      let(:hash) do
        {
          users: [
            { firstName: 'Lucy',   email: 'lucy@gmail.com' },
            { firstName: 'Bobby',  email: 'bobby@hotmail.com' },
            { email: 'richard@tracy.com' },
            { firstName: 'Arthur', email: 'arthur@kamelot.uk' }
          ]
        }
      end

      let(:expected) do
        [
          Person.new('Lucy'),
          Person.new('Bobby'),
          Person.new('Arthur')
        ]
      end

      before do
        # rubocop:disable RSpec/SubjectStub
        allow(instance).to receive(:warn)
        # rubocop:enable RSpec/SubjectStub
      end

      it 'Returns created users' do
        expect(instance.users).to eq(expected)
      end

      it 'Triggers warn 3 times' do
        instance.users
        instance.users
        expect(instance).to have_received(:warn).exactly(3).times
      end
    end

    describe 'working with snake case hash' do
      let(:clazz) { JobSeeker }

      let(:hash) do
        {
          'applicants' => [
            {
              'full_name' => 'Robert Hatz',
              'email' => 'robert.hatz@gmail.com'
            }, {
              'full_name' => 'Marina Wantz',
              'email' => 'marina.wantz@gmail.com'
            }, {
              'email' => 'albert.witz@gmail.com'
            }
          ]
        }
      end

      let(:expected) do
        ['Robert Hatz', 'Marina Wantz', 'John Doe']
      end

      it 'treats keys as snake case keys' do
        expect(instance.applicants).to eq(expected)
      end
    end

    describe 'Deep path with flatten' do
      let(:clazz) { ShoppingMall }

      let(:hash) do
        {
          floors: [{
            name: 'ground', stores: [{
              name: 'Starbucks', customers: %w[
                John Bobby Maria
              ]
            }, {
              name: 'Pizza Hut', customers: %w[
                Danny LJ
              ]
            }]
          }, {
            name: 'first', stores: [{
              name: 'Disney', customers: %w[
                Robert Richard
              ]
            }, {
              name: 'Comix', customers: %w[
                Linda Ariel
              ]
            }]
          }]
        }
      end

      let(:expected) do
        %w[
          John Bobby Maria
          Danny LJ
          Robert Richard
          Linda Ariel
        ]
      end

      it 'returns all the customers in one array' do
        expect(instance.customers).to eq(expected)
      end
    end
  end
end
