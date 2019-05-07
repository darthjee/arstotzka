# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::KeyReader do
  describe 'yard' do
    describe '#read' do
      describe 'Simple Usage' do
        subject(:reader) { described_class.new hash, key }

        let(:key)  { 'the_key' }
        let(:hash) { { theKey: 'value' } }

        it 'reads the value' do
          expect(reader.read).to eq('value')
        end
      end

      describe 'Specifying snakecase' do
        subject(:reader) { described_class.new hash, key, case: :snake }

        let(:key)  { 'TheKey' }
        let(:hash) { { 'the_key' => 'value' } }

        it 'reads the value' do
          expect(reader.read).to eq('value')
        end
      end
    end
  end
end
