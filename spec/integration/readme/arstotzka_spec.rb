# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka do
  describe 'default option' do
    subject(:star_gazer) do
      StarGazer.new(hash).favorite_star
    end

    let(:hash) { {} }

    context 'when node is not found' do
      it 'returns the default before wrapping' do
        expect(star_gazer.name).to eq('Sun')
      end

      it 'wraps the returned value in a class' do
        expect(star_gazer).to be_a(Star)
      end
    end

    context 'when node is not missing' do
      let(:hash) do
        {
          universe: {
            star: { name: 'Antares' }
          }
        }
      end

      it 'returns the value before wrapping' do
        expect(star_gazer.name).to eq('Antares')
      end

      it 'wraps the returned value in a class' do
        expect(star_gazer).to be_a(Star)
      end
    end
  end
end
