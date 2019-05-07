# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::KeyReader do
  subject(:reader) { described_class.new hash, key, options }

  let(:key) { 'key' }

  context 'when no options are given' do
    let(:options) { {} }

    context 'when hash keys are symbols' do
      let(:hash) { { key: 'value' } }

      it 'reads the value' do
        expect(reader.read).to eq('value')
      end
    end

    context 'when hash keys are strings' do
      let(:hash) { { 'key' => 'value' } }

      it 'reads the value' do
        expect(reader.read).to eq('value')
      end
    end

    context 'when key is snake_case and hash keys are camelcase' do
      let(:key)  { 'the_key' }
      let(:hash) { { theKey: 'value' } }

      it 'reads the value' do
        expect(reader.read).to eq('value')
      end
    end
  end

  context 'when case options are given' do
    context 'when key is camelcase and hash keys are snake_case and case option is snake' do
      let(:options) { { case: :snake } }
      let(:key)     { 'theKey' }
      let(:hash)    { { the_key: 'value' } }

      it 'reads the value' do
        expect(reader.read).to eq('value')
      end
    end

    context 'when key is snakecase and hash keys are lower camelcase and case option is lower' do
      let(:options) { { case: :lower_camel } }
      let(:key)     { 'the_key' }
      let(:hash)    { { theKey: 'value' } }

      it 'reads the value' do
        expect(reader.read).to eq('value')
      end
    end

    context 'when key is snakecase and hash keys are upper camelcase and case option is upper' do
      let(:options) { { case: :upper_camel } }
      let(:key)     { 'the_key' }
      let(:hash)    { { TheKey: 'value' } }

      it 'reads the value' do
        expect(reader.read).to eq('value')
      end
    end
  end
end
