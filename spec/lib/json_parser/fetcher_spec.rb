require 'spec_helper'

describe JsonParser::Fetcher do
  class JsonParser::Fetcher::Dummy
  end

  let(:subject) do
    described_class.new json, path, instance, default_options.merge(options)
  end
  let(:path) { '' }
  let(:default_options) { { case_type: :snake} }
  let(:instance) { JsonParser::Fetcher::Dummy.new }

  describe 'flatten options' do
    let(:json) { [[[1,2],[3,4]],[[5,6],[7,8]]] }

    context 'when flatten option is true' do
      let(:options) { { flatten: true } }

      it 'returns the fetched value flattened' do
        expect(subject.fetch).to eq((1..8).to_a)
      end

      context 'when value is not an array' do
        let(:json) { 1 }

        it 'returns the fetched value flattened' do
          expect(subject.fetch).to eq(1)
        end
      end
    end

    context 'when flatten option is false' do
      let(:options) { { flatten: false } }

      it 'returns the fetched value non flattened' do
        expect(subject.fetch).to eq(json)
      end
    end
  end
end
