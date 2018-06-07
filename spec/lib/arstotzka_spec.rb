require 'spec_helper'

describe Arstotzka do
  let(:dummy) { Arstotzka::Dummy.new(json) }
  let(:json) { load_json_fixture_file('arstotzka.json') }
  let(:value) { dummy.public_send(attribute) }

  context 'when parser is configured with no options' do
    let(:attribute) { :id }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['id'])
    end
  end

  context 'when parser is configured with a path' do
    let(:attribute) { :name }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['user']['name'])
    end
  end

  context 'when configuring full path' do
    let(:attribute) { :father_name }

    it 'returns nil' do
      expect(value).to eq(json['father']['name'])
    end
  end

  context 'when caching the value' do
    let(:attribute) { :age }
    let!(:old_value) { json['age'] }
    before do
      dummy.age
      json['age'] = old_value + 100
    end

    it 'returns cached value' do
      expect(value).to eq(old_value)
    end
  end

  context 'when wrapping it with a class' do
    let(:attribute) { :house }

    it 'returns an onject wrap' do
      expect(value).to be_a(House)
    end

    it 'creates the object with the given json' do
      expect(value.age).to eq(json['house']['age'])
      expect(value.value).to eq(json['house']['value'])
      expect(value.floors).to eq(json['house']['floors'])
    end

    context 'when dealing with an array' do
      let(:attribute) { :games }

      it 'returns an array of json wrapped' do
        expect(value).to be_a(Array)
        value.each do |object|
          expect(object).to be_a(Game)
        end
      end

      context 'when dealing with multiple level arrays' do
        let(:attribute) { :games }
        before do
          json['games'].map! { |j| [j] }
        end

        it 'returns an array of json wrapped' do
          expect(value).to be_a(Array)
          value.each do |object|
            expect(object).to be_a(Array)
            object.each do |game|
              expect(game).to be_a(Game)
            end
          end
        end
      end
    end
  end

  context 'when wrapping it with a class and caching' do
    let(:attribute) { :old_house }
    let!(:old_value) { json['oldHouse'] }
    before do
      dummy.old_house
      json['oldHouse'] = {}
    end

    it 'returns an onject wrap' do
      expect(value).to be_a(House)
    end

    it 'creates the object with the given json' do
      expect(value.age).not_to eq(json['oldHouse']['age'])
      expect(value.age).to eq(old_value['age'])
      expect(value.value).not_to eq(json['oldHouse']['value'])
      expect(value.value).to eq(old_value['value'])
      expect(value.floors).not_to eq(json['oldHouse']['floors'])
      expect(value.floors).to eq(old_value['floors'])
    end
  end

  context 'when passing an after filter' do
    let(:attribute) { :games_filtered }

    it 'applies the filter after parsing the json' do
      expect(value.map(&:publisher)).not_to include('sega')
    end
  end

  context 'when casting the result' do
    class Arstotzka::Dummy
      expose :float_value, type: :float
    end

    let(:json) { { floatValue: '1' } }
    let(:attribute) { :float_value }

    it do
      expect(value).to be_a(Float)
    end
  end
end
