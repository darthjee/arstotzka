# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Reader do
  describe 'yard' do
    subject { described_class.new(path: path, case_type: case_type) }

    let(:path) { %w[person full_name] }
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
          expect(subject.read(hash, 1)).to eq('John')
        end

        context 'when key is missing' do
          let(:path) { %w[person car_collection model] }

          it do
            expect do
              subject.read(hash, 1)
            end.to raise_error(Arstotzka::Exception::KeyNotFound)
          end
        end
      end

      context 'when using lowerCamel' do
        let(:case_type) { :lower_camel }
        let(:path) { %w[person car_collection model] }

        it 'fetches the value using lower camel case key' do
          expected = [
            { maker: 'Ford', 'model' => 'Model A' },
            { maker: 'BMW', 'model' => 'Jetta' }
          ]
          expect(subject.read(hash, 1)).to eq(expected)
        end
      end

      context 'when using UpperCamel' do
        let(:case_type) { :upper_camel }
        let(:path) { %w[person age] }

        it 'fetches the value using uper camel case key' do
          expect(subject.read(hash, 1)).to eq(23)
        end
      end
    end

    describe '#ended?' do
      context 'when the fetches have not ended' do
        it do
          expect(subject.ended?(1)).to be_falsey
        end
      end

      context 'when the fetches have ended' do
        it do
          expect(subject.ended?(2)).to be_truthy
        end
      end
    end
  end
end
