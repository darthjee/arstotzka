# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Reader do
  describe 'yard' do
    subject(:reader) { described_class.new(full_path: full_path, case: case_type) }

    let(:keys)      { %w[person full_name] }
    let(:full_path) { keys.join('.') }
    let(:case_type) { :snake }

    describe '#read' do
      let(:hash) do
        {
          full_name: 'John',
          'Age' => 23,
          'carCollection' => [
            { maker: 'Ford', 'model' => 'Model A' },
            { maker: 'BMW', 'model' => 'Jetta' }
          ]
        }
      end

      context 'when using snake_case' do
        it 'fetches the value using snake case key' do
          expect(reader.read(hash, 1)).to eq('John')
        end

        context 'when key is missing' do
          let(:keys) { %w[person car_collection model] }

          it do
            expect do
              reader.read(hash, 1)
            end.to raise_error(Arstotzka::Exception::KeyNotFound)
          end
        end
      end

      context 'when using lowerCamel' do
        let(:case_type) { :lower_camel }
        let(:keys)      { %w[person car_collection model] }

        it 'fetches the value using lower camel case key' do
          expected = [
            { maker: 'Ford', 'model' => 'Model A' },
            { maker: 'BMW', 'model' => 'Jetta' }
          ]
          expect(reader.read(hash, 1)).to eq(expected)
        end
      end

      context 'when using UpperCamel' do
        let(:case_type) { :upper_camel }
        let(:keys) { %w[person age] }

        it 'fetches the value using uper camel case key' do
          expect(reader.read(hash, 1)).to eq(23)
        end
      end
    end

    describe '#ended?' do
      context 'when the fetches have not ended' do
        it do
          expect(reader).not_to be_ended(1)
        end
      end

      context 'when the fetches have ended' do
        it do
          expect(reader).to be_ended(2)
        end
      end
    end
  end
end
