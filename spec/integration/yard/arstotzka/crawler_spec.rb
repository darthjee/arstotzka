# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Crawler do
  describe 'yard' do
    subject(:crawler) do
      described_class.new(keys: keys, **options)
    end

    let(:options) { {} }
    let(:keys)    { %w[person information first_name] }
    let(:hash) do
      {
        person: {
          'information' => {
            'firstName' => 'John'
          }
        }
      }
    end

    it 'crawls to find the value' do
      expect(crawler.value(hash)).to eq('John')
    end

    describe '#value' do
      context 'when hash contains the keys' do
        it 'crawls to find the value' do
          expect(crawler.value(hash)).to eq('John')
        end
      end

      context 'when we have an array of arrays' do
        let(:keys)    { %w[companies games hero_name] }
        let(:options) { { compact: true, case_type: :snake } }
        let(:hash) do
          {
            'companies' => [{
              name: 'Lucas Pope',
              games: [{
                'name' => 'papers, please'
              }, {
                'name' => 'TheNextBigThing',
                hero_name: 'Rakhar'
              }]
            }, {
              name: 'Old Company'
            }]
          }
        end

        it 'crawls to find the value' do
          expect(crawler.value(hash)).to eq([['Rakhar']])
        end

        context 'with default value' do
          let(:options) { { compact: true, case_type: :snake, default: 'NO HERO' } }

          it 'return default value for missed keys' do
            expect(crawler.value(hash)).to eq([['NO HERO', 'Rakhar'], 'NO HERO'])
          end
        end

        context 'when block is given' do
          subject(:crawler) do
            described_class.new(keys: keys, **options) { |value| value&.to_sym }
          end

          it 'returns the post processed values' do
            expect(crawler.value(hash)).to eq([[:Rakhar]])
          end
        end
      end
    end
  end
end
