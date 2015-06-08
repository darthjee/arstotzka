require 'spec_helper'

describe JsonParser::Crawler do
  let(:subject) do
    described_class.new path, default_options.merge(options), &block
  end
  let(:block) { proc { |v| v } }
  let(:path) { '' }
  let(:default_options) { { case_type: :snake} }
  let(:options) { {} }
  let(:json) { load_json_fixture_file('json_parser.json') }
  let(:value) { subject.crawl(json) }

  context 'when parsing with a path' do
    let(:path) { %w(user name) }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['user']['name'])
    end
  end

  context 'crawler finds a nil attribute' do
    let(:path) { %w(car model) }

    it 'returns nil' do
      expect(value).to be_nil
    end

    it do
      expect { value }.not_to raise_error
    end
  end

  context 'when json is empty' do
    let(:json) { nil }
    let(:path) { %w(car model) }

    it 'returns nil' do
      expect(value).to be_nil
    end

    it do
      expect { value }.not_to raise_error
    end
  end
end
