# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::FetcherBuilder do
  describe 'yard' do
    describe '#build' do
      subject(:builder) { described_class.new(options) }

      let(:fetcher)  { builder.build(instance) }
      let(:instance) { MyModel.new(hash) }

      describe 'Building a simple fetcher' do
        let(:options) { { key: :id, path: :person } }

        let(:hash) do
          {
            person: {
              id: 101
            }
          }
        end

        it 'builds a fetcher capable of fetching value' do
          expect(fetcher.fetch).to eq(101)
        end
      end

      describe 'Builder a fetcher using full path' do
        let(:options) do
          {
            key:       :player_ids,
            full_path: 'teams.players.person_id',
            flatten:   true,
            case:      :snake
          }
        end

        let(:hash) do
          {
            teams: [
              {
                name: 'Team War',
                players: [
                  { person_id: 101 },
                  { person_id: 102 }
                ]
              }, {
                name: 'Team not War',
                players: [
                  { person_id: 201 },
                  { person_id: 202 }
                ]
              }
            ]
          }
        end

        it 'builds a fetcher capable of fetching value' do
          expect(fetcher.fetch).to eq([101, 102, 201, 202])
        end
      end

      describe 'Post processing results' do
        let(:instance) { StarGazer.new(hash) }
        let(:hash) do
          {
            stars: [
              { name: 'Sun',         color: 'yellow' },
              { name: 'HB2840-B',    color: 'blue' },
              { name: 'Krypton Sun', color: 'red' },
              { name: 'HB0124-C',    color: 'yellow' },
              { name: 'HB0942-C',    color: 'red' }
            ]
          }
        end
        let(:options) do
          { key: :stars, klass: Star, after: :only_yellow }
        end

        it 'builds a fetcher capable of fetching and filtering value' do
          expect(fetcher.fetch)
            .to eq([
                     Star.new(name: 'Sun', color: 'yellow'),
                     Star.new(name: 'HB0124-C', color: 'yellow')
                   ])
        end
      end
    end
  end
end
