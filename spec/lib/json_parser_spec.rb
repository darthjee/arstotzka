require 'spec_helper'

describe JsonParser do
  class JsonParser::House
    include JsonParser
    include ::SafeAttributeAssignment
    attr_reader :json

    json_parse :age, :value, :floors

    def initialize(json)
      @json = json
    end
  end

  class JsonParser::Game
    include JsonParser
    include SafeAttributeAssignment
    attr_reader :json

    json_parse :name, :publisher

    def initialize(json)
      @json = json
    end
  end

  class JsonParser::Dummy
    include JsonParser
    attr_reader :json

    json_parse :id
    json_parse :name, path: 'user'
    json_parse :model, path: 'car'
    json_parse :father_name, full_path: 'father.name'
    json_parse :age, cached: true
    json_parse :has_money
    json_parse :house, class: JsonParser::House
    json_parse :old_house, class: JsonParser::House, cached: true
    json_parse :games, class: JsonParser::Game
    json_parse :species_name, full_path: 'animals.race.species.name', compact: true
    json_parse :games_filtered, class: JsonParser::Game, after: :filter_games, full_path: 'games'

    def initialize(json)
      @json = json
    end

    def filter_games(games)
      games.select do |g|
        g.publisher != 'sega'
      end
    end
  end

  let(:dummy) { JsonParser::Dummy.new(json) }
  let(:json) { load_json_fixture_file('json_parser.json') }
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
      expect(value).to be_a(JsonParser::House)
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
          expect(object).to be_a(JsonParser::Game)
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
              expect(game).to be_a(JsonParser::Game)
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
      expect(value).to be_a(JsonParser::House)
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


  context 'when using a upper camel case' do
    class JsonParser::Dummy
      json_parse :upper_case, case: :upper_camel
    end

    let(:json) { { UpperCase: 'upper', upperCase: 'lower' }.stringify_keys }
    let(:attribute) { :upper_case }

    it 'fetches from upper camel cased fields' do
      expect(value).to eq('upper')
    end
  end

  context 'when using a symbol keys' do
    let(:json) { load_json_fixture_file('json_parser.json').symbolize_keys }
    let(:attribute) { :id }

    it 'fetches from symbol keys' do
      expect(value).to eq(json[:id])
    end

    context 'parser finds a nil attribute' do
      let(:attribute) { :model }

      it 'returns nil' do
        expect(value).to be_nil
      end

      it do
        expect { value }.not_to raise_error
      end
    end
  end

  context 'when using key with false value' do
    let(:attribute) { :has_money }
    before do
      json['hasMoney'] = false
    end

    context 'with string keys' do
      it { expect(value).to be_falsey }
      it { expect(value).not_to be_nil }
    end

    context 'with symbol keys' do
      before do
        json.symbolize_keys!
      end

      it { expect(value).to be_falsey }
      it { expect(value).not_to be_nil }
    end
  end

  context 'when casting the result' do
    class JsonParser::Dummy
      json_parse :float_value, type: :float
    end

    let(:json) { { floatValue: '1' } }
    let(:attribute) { :float_value }

    it do
      expect(value).to be_a(Float)
    end
  end
end
