# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Fetcher::Cache do
  describe 'yard' do
    let(:instance) { Object.new }

    let(:options) do
      Arstotzka::Options.new(
        options_hash.merge(key: :x, instance: instance)
      )
    end

    describe '#fetch' do
      describe 'without cache option' do
        subject(:cache) do
          described_class.new do
            (settings[:min]..settings[:max]).sum
          end
        end

        let(:options_hash) { {} }
        let(:settings)     { { min: 1, max: 100 } }

        it 'retrieves value from block' do
          expect(cache.fetch).to eq(5050)
        end

        it 'retrieves every time' do
          cache.fetch
          settings[:max] = 10
          expect(cache.fetch).to eq(55)
        end
      end

      describe 'with simple cache option' do
        subject(:cache) do
          described_class.new(options) do
            (settings[:min]..settings[:max]).sum if settings[:calculate]
          end
        end

        let(:options_hash) { { cached: true } }
        let(:settings)     { { calculate: false, min: 1, max: 100 } }

        it 'returns nil on first attempt' do
          expect(cache.fetch).to be_nil
        end

        it 'recalculates when cache is nil' do
          cache.fetch
          settings[:calculate] = true

          expect(cache.fetch).to eq(5050)
        end

        it ' does not recalculates when cache is not nil' do
          cache.fetch
          settings[:calculate] = true
          cache.fetch
          settings[:max] = 10

          expect(cache.fetch).to eq(5050)
        end
      end

      describe 'with full cache option' do
        subject(:cache) do
          described_class.new(options) do
            (settings[:min]..settings[:max]).sum if settings[:calculate]
          end
        end

        let(:options_hash) { { cached: :full } }
        let(:settings)     { { calculate: false, min: 1, max: 100 } }

        it 'returns nil on first attempt' do
          expect(cache.fetch).to be_nil
        end

        it 'does not recalculate when cache is nil' do
          cache.fetch
          settings[:calculate] = true

          expect(cache.fetch).to be_nil
        end
      end
    end
  end
end
