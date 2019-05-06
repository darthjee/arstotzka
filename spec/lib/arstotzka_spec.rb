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
        key: :name,
        path: 'user',
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

    context 'when fetching using string' do
      it 'returns correct fetcher' do
        expect(klass.fetcher_for('name', instance))
          .to eq(expected)
      end
    end

    context 'when fetcher was never added' do
      it do
        expect { klass.fetcher_for(:new_attribute, instance) }
          .to raise_error(
            Arstotzka::Exception::FetcherBuilderNotFound,
            "FetcherBuild not found for new_attribute on #{klass}"
        )
      end

      context 'when fetching using string' do
        it do
          expect { klass.fetcher_for('new_attribute', instance) }
            .to raise_error(
              Arstotzka::Exception::FetcherBuilderNotFound,
              "FetcherBuild not found for new_attribute on #{klass}"
          )
        end
      end
    end

    context 'when dealing with subclass' do
      let(:klass) { Class.new(Arstotzka::Dummy) }

      it do
        expect { klass.fetcher_for(:name, instance) }
          .not_to raise_error
      end

      context 'when fetching using string' do
        it 'returns correct fetcher' do
          expect(klass.fetcher_for('name', instance))
            .to eq(expected)
        end
      end

      context 'when fetcher was never added' do
        it do
          expect { klass.fetcher_for(:new_attribute, instance) }
            .to raise_error(
              Arstotzka::Exception::FetcherBuilderNotFound,
              "FetcherBuild not found for new_attribute on #{klass}"
          )
        end

        context 'when fetching using string' do
          it do
            expect { klass.fetcher_for('new_attribute', instance) }
              .to raise_error(
                Arstotzka::Exception::FetcherBuilderNotFound,
                "FetcherBuild not found for new_attribute on #{klass}"
            )
          end
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
end
