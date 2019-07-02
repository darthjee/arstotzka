# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Config do
  describe 'yard' do
    subject(:config) { Arstotzka.config }

    describe '#options' do
      let(:overrides) { { klass: Person } }

      let(:expected) do
        {
          after:      false,
          after_each: nil,
          cached:     false,
          case:       :snake,
          compact:    false,
          default:    nil,
          flatten:    false,
          full_path:  nil,
          json:       :json,
          klass:      Person,
          path:       nil,
          type:       :none
        }
      end

      before do
        Arstotzka.configure do |config|
          config.case :snake
        end
      end

      after { Arstotzka.reset_config }

      it 'configure options to use snake case' do
        expect(config.options(overrides).to_h).to eq(expected)
      end
    end
  end
end
