require 'spec_helper'

describe Arstotzka do
  describe :yard do
    subject { Collector.new(hash) }

    let(:hash) { JSON.parse json }
    let(:json) do
      <<-JSON
        {
          "person": {
            "fullName": "Kelly Khan",
            "age": 32,
            "gender": "woman"
          },
          "collections": {
            "cars": [{
              "maker": "Volkswagen",
              "model": "Jetta",
              "units": [{
                "nickName": "Betty",
                "year": 2013
              }, {
                "nickName": "Roger",
                "year": 2014
              }]
            }, {
              "maker": "Ferrari",
              "model": "Ferrari X1",
              "units": [{
                "nickName": "Geronimo",
                "year": 2014
              }]
            }, {
              "maker": "Fiat",
              "model": "Uno",
              "units": [{
                "year": 1998
              }]
            }],
            "games":[{
              "producer": "Lucas Pope",
              "titles": [{
                "name": "papers, please",
                "played": "10.2%"
              }, {
                "name": "TheNextBigThing",
                "played": "100%"
              }]
            }, {
              "producer": "Nintendo",
              "titles": [{
                "name": "Zelda",
                "played": "90%"
              }]
            }]
          }
        }
      JSON
    end

    describe '#full_name' do
      it 'returns the full_name' do
        expect(subject.full_name).to eq('Kelly Khan')
      end
    end

    describe '#age' do
      it 'returns the age' do
        expect(subject.age).to eq(32)
      end
    end

    describe '#gender' do
      it 'returns person gender' do
        expect(subject.gender).to eq(Collector::FEMALE)
      end
    end

    describe '#car_names' do
      it 'returns the nick names of the cars' do
        expect(subject.car_names).to eq(%w(Betty Roger Geronimo MissingName))
      end
    end

    describe '#finished_games' do
      it 'returns the finished games' do
        expected = [
          Collector::Game.new(name: "TheNextBigThing", played: 100.0),
          Collector::Game.new(name: "Zelda", played: 90.0)
        ]
        expect(subject.finished_games).to eq(expected)
      end
    end
  end
end
