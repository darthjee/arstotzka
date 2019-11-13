# frozen_string_literal: true

describe Arstotzka::TypeCast do
  subject(:model) { TypeCaster.new(hash) }

  let(:hash) do
    {
      age:     '10',
      payload: { 'key' => 'value' },
      price:   '1.75',
      type:    'type_a'
    }
  end

  describe 'yard' do
    describe 'integer' do
      it 'converts string to integer' do
        expect(model.age).to eq(10)
      end
    end

    describe 'string' do
      it 'converts value to string' do
        expect(model.payload).to eq('{"key"=>"value"}')
      end
    end

    describe 'float' do
      it 'converts value to string' do
        expect(model.price).to eq(1.75)
      end
    end

    describe 'symbol' do
      it 'converts value to string' do
        expect(model.type).to eq(:type_a)
      end
    end

    describe 'extending' do
      subject(:model) { CarCollector.new(hash) }

      let(:hash) do
        {
          cars: [{
            unit: { model: 'fox', maker: 'volkswagen' }
          }, {
            unit: { 'model' => 'focus', 'maker' => 'ford' }
          }]
        }
      end

      it 'converts each unit to be a car' do
        expect(model.cars.first).to be_a(Car)
      end

      it 'converts using the given hash' do
        expect(model.cars.map(&:model)).to eq(%w[fox focus])
      end
    end
  end
end
