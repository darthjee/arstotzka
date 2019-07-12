# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::KeyChanger do
  subject(:key_changer) { described_class.new(base_key, options) }

  describe '#key' do
    let(:base_key) { 'the_key' }

    context 'when no options are given' do
      let(:options) { {} }

      it 'returns lower camelized key' do
        expect(key_changer.key).to eq('theKey')
      end
    end

    context 'when setting upper camel' do
      let(:options) { { case: :upper_camel } }

      it 'returns upper camelized key' do
        expect(key_changer.key).to eq('TheKey')
      end
    end

    context 'when setting snake' do
      let(:options)  { { case: :snake } }
      let(:base_key) { 'TheKey' }

      it 'returns lower snakecased key' do
        expect(key_changer.key).to eq('the_key')
      end
    end
  end
end
