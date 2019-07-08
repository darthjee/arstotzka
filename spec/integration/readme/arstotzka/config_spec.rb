# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Config do
  describe 'readme' do
    subject(:restaurant) { Restaurant.new(hash) }

    let(:hash) do
      {
        restaurant: {
          complete_meals: {
            dishes: %w[
              Goulash
              Spaghetti
              Pizza
            ]
          }
        }
      }
    end

    after { Arstotzka.reset_config }

    it 'does not find the values' do
      expect { restaurant.dishes }.to raise_error(NoMethodError)
    end

    context 'when configuring json to be instance_variable' do
      before do
        Arstotzka.configure { json :@hash }
      end

      it do
        expect(restaurant.dishes).to be_nil
      end

      context 'when setting default case to snake' do
        before do
          Arstotzka.configure { |c| c.case :snake }
        end

        it do
          expect(restaurant.dishes)
            .to eq(%w[
                     Goulash Spaghetti Pizza
                   ])
        end
      end
    end
  end
end
