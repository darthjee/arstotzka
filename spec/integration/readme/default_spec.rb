require 'spec_helper'

describe 'default option' do
  subject do
    StarGazer.new(hash).favorite_star
  end

  let(:hash) { {} }

  context 'when node is not found' do
    it 'returns the default before wrapping' do
      expect(subject.name).to eq('Sun')
    end

    it 'wraps the returned value in a class' do
      expect(subject).to be_a(Star)
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
      expect(subject.name).to eq('Antares')
    end

    it 'wraps the returned value in a class' do
      expect(subject).to be_a(Star)
    end
  end
end
