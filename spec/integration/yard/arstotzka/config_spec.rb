# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Config do
  describe 'yard' do
    subject(:config) { Arstotzka.config }

    after { Arstotzka.reset_config }

    describe 'Redefining json method and case type' do
      let(:office) { Office.new(hash) }

      let(:hash) do
        {
          employes: [{
            first_name: 'Rob'
          }, {
            first_name: 'Klara'
          }]
        }
      end

      let(:error_message) do
        "undefined method `json' for #{office}\nDid you mean?  JSON"
      end

      it do
        expect { office.employes }
          .to raise_error(NoMethodError, error_message)
      end

      context 'when json option is defined' do
        before { Arstotzka.configure { json :@hash } }

        it do
          expect { Arstotzka.configure { |c| c.case :snake } }
            .to change(office, :employes)
            .from([]).to(%w[Rob Klara])
        end
      end
    end

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
          json:       :json,
          klass:      Person,
          type:       :none,
          full_path:  nil,
          key:        nil,
          instance:   nil,
          path:       nil
        }
      end

      before do
        Arstotzka.configure do |config|
          config.case :snake
        end
      end

      it 'configure options to use snake case' do
        expect(config.options(overrides).to_h).to eq(expected)
      end
    end
  end
end
