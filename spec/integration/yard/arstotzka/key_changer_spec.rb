# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::KeyChanger do
  describe '#yard' do
    subject(:key_changer) do
      described_class.new('the_key', case: :upper_camel)
    end

    it 'converts key case' do
      expect(key_changer.key).to eq('TheKey')
    end
  end
end
