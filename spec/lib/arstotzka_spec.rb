# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka do
  let(:dummy_class) { Arstotzka::Dummy }
  let(:dummy)       { dummy_class.new(json) }
  let(:json)        { load_json_fixture_file('arstotzka.json') }
  let(:value)       { dummy.public_send(attribute) }

  describe '.add_fether' do
    let(:klass) { Class.new(Arstotzka::Dummy) }

    it do
      expect { klass.add_fetcher(:new_attribute) }
        .to change { klass.send(:fetcher_builders).keys }
        .to([:new_attribute])
    end
  end

  describe '.fetcher_for' do
    let(:klass)    { Arstotzka::Dummy }
    let(:instance) { klass.new({}) }
    let(:expected) do
      Arstotzka::Fetcher.new(
        key:      :name,
        path:     'user',
        instance: instance
      )
    end

    it do
      expect(klass.fetcher_for(:name, instance))
        .to be_a(Arstotzka::Fetcher)
    end

    it 'returns correct fetcher' do
      expect(klass.fetcher_for(:name, instance))
        .to eq(expected)
    end

    context 'when fetcher was never added' do
      it do
        expect { klass.fetcher_for(:new_attribute, instance) }
          .to raise_error(
            Arstotzka::Exception::FetcherBuilderNotFound,
            "FetcherBuild not found for new_attribute on #{klass}"
          )
      end
    end

    context 'when dealing with subclass' do
      let(:klass) { Class.new(Arstotzka::Dummy) }

      it do
        expect { klass.fetcher_for(:name, instance) }
          .not_to raise_error
      end

      context 'when fetcher was never added' do
        it do
          expect { klass.fetcher_for(:new_attribute, instance) }
            .to raise_error(
              Arstotzka::Exception::FetcherBuilderNotFound,
              "FetcherBuild not found for new_attribute on #{klass}"
            )
        end
      end
    end
  end

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
    let(:attribute)  { :age }
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

    it 'creates the object with a method that is instantiated using the hash' do
      expect(value.age).to eq(json['house']['age'])
    end

    context 'when dealing with an array' do
      let(:attribute) { :games }

      it 'returns an array' do
        expect(value).to be_a(Array)
      end

      it 'returns an array of json wrapped' do
        expect(value).to all(be_a(Game))
      end

      context 'when dealing with multiple level arrays' do
        let(:attribute) { :games }

        before do
          json['games'].map! { |j| [j] }
        end

        it 'returns an array' do
          expect(value).to be_a(Array)
        end

        it 'returns an array of arrays' do
          expect(value).to all(be_a(Array))
        end

        it 'wraps each end element' do
          expect(value).to all(all(be_a(Game)))
        end
      end
    end
  end

  context 'when wrapping it with a class and caching' do
    let(:attribute)  { :old_house }
    let!(:old_value) { json['oldHouse'] }

    it 'returns an onject wrap' do
      expect(value).to be_a(House)
    end

    it 'creates the object with the given json' do
      expect(value.age).to eq(old_value['age'])
    end

    it 'caches the resulting object' do
      expect do
        json['oldHouse'] = {}
      end.not_to(change { dummy.old_house.age })
    end
  end

  context 'when passing an after filter' do
    let(:attribute) { :games_filtered }

    it 'applies the filter after parsing the json' do
      expect(value.map(&:publisher)).not_to include('sega')
    end
  end

  context 'when casting the result' do
    let(:json)      { { floatValue: '1' } }
    let(:attribute) { :float_value }
    let(:dummy_class) do
      Class.new(Arstotzka::Dummy) do
        expose :float_value, type: :float
      end
    end

    it do
      expect(value).to be_a(Float)
    end
  end

  context 'when class is a child' do
    let(:klass)     { Class.new(Arstotzka::Dummy) }
    let(:attribute) { :name }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['user']['name'])
    end
  end

  context 'when changing configuration of case after class declaration' do
    let(:json) { { the_value: 'snake', theValue: 'lower_camel', TheValue: 'upper_camel' } }

    let(:dummy_class) do
      Class.new(Arstotzka::Dummy) do
        expose :the_value
      end
    end

    after { described_class.reset_config }

    context 'when changing case to snake' do
      it 'changes the way the value is fetched' do
        expect { described_class.configure { |c| c.case :snake } }
          .to change(dummy, :the_value)
          .from('lower_camel').to('snake')
      end
    end

    context 'when changing case to upper_camel' do
      it 'changes the way the value is fetched' do
        expect { described_class.configure { |c| c.case :upper_camel } }
          .to change(dummy, :the_value)
          .from('lower_camel').to('upper_camel')
      end
    end

    context 'when expose was set to cache' do
      let(:dummy_class) do
        Class.new(Arstotzka::Dummy) do
          expose :the_value, cached: true
        end
      end

      it 'does not change the way the value is fetched' do
        expect { described_class.configure { |c| c.case :snake } }
          .not_to change(dummy, :the_value)
      end
    end

    context 'when arstotka was set to cache' do
      before { described_class.configure { cached true } }

      it 'does not change the way the value is fetched' do
        expect { described_class.configure { |c| c.case :snake } }
          .not_to change(dummy, :the_value)
      end
    end

    context 'when expose defined the case' do
      let(:dummy_class) do
        Class.new(Arstotzka::Dummy) do
          expose :the_value, case: :upper_camel
        end
      end

      it 'does not change the way the value is fetched' do
        expect { described_class.configure { |c| c.case :snake } }
          .not_to change(dummy, :the_value)
      end
    end
  end

  context 'when changing configuration of cached after class declaration' do
    let(:json) { { the_value: 'old value' } }

    let(:dummy_class) do
      Class.new(Arstotzka::Dummy) do
        expose :the_value, case: :snake
      end
    end

    after { described_class.reset_config }

    context 'when cached is defined as true after in the config' do
      context 'when first method call is after value change' do
        let(:block) do
          proc do
            described_class.configure { cached true }
            json[:the_value] = :symbol
          end
        end

        it 'caches after cache change' do
          expect(&block).to change(dummy, :the_value)
            .from('old value').to(:symbol)
        end
      end

      context 'when first method call is before value change' do
        let(:block) do
          proc do
            described_class.configure { cached true }
            dummy.the_value
            json[:the_value] = :symbol
          end
        end

        it 'caches the original value' do
          expect(&block).not_to change(dummy, :the_value)
        end
      end
    end

    context 'when cached is defined as false after in the config' do
      before { described_class.configure { cached true } }

      let(:block) do
        proc do
          described_class.configure { cached false }
          json[:the_value] = :symbol
        end
      end

      it 'changes value' do
        expect(&block).to change(dummy, :the_value)
          .from('old value').to(:symbol)
      end
    end

    context 'when cached was defined in expose' do
      context 'when cached was set as true' do
        let(:dummy_class) do
          Class.new(Arstotzka::Dummy) do
            expose :the_value, case: :snake, cached: true
          end
        end

        let(:block) do
          proc do
            described_class.configure { cached false }
            json[:the_value] = :symbol
          end
        end

        it 'does not change cached state' do
          expect(&block).not_to change(dummy, :the_value)
        end
      end

      context 'when cached was set as false' do
        let(:dummy_class) do
          Class.new(Arstotzka::Dummy) do
            expose :the_value, case: :snake, cached: false
          end
        end

        let(:block) do
          proc do
            described_class.configure { cached true }
            dummy.the_value
            json[:the_value] = :symbol
          end
        end

        it 'does not change cached state' do
          expect(&block).to change(dummy, :the_value)
            .from('old value').to(:symbol)
        end
      end
    end
  end
end
