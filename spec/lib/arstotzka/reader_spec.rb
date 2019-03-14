# frozen_string_literal: true

require 'spec_helper'

shared_examples 'reader fetchin value' do
  it do
    expect { reader.read(json, index) }.not_to raise_error
  end

  it do
    expect(reader.read(json, index)).not_to be_nil
  end

  it 'returns the evaluated value' do
    expect(reader.read(json, index)).to eq(expected)
  end

  context 'when the json has symbolized_keys' do
    it 'returns the evaluated value' do
      expect(reader.read(sym_json, index)).to eq(expected)
    end
  end
end

describe Arstotzka::Reader do
  subject(:reader) do
    described_class.new(full_path: full_path, case: case_type)
  end

  let(:keys)      { %w[user full_name] }
  let(:full_path) { keys.join('.') }
  let(:json_file) { 'complete_person.json' }
  let(:full_json) { load_json_fixture_file(json_file) }
  let(:json)      { full_json }
  let(:sym_json)  { json.symbolize_keys }
  let(:case_type) { :snake }
  let(:index)     { 0 }

  describe '#read' do
    context 'when the key is found' do
      let(:expected) { json['user'] }

      it_behaves_like 'reader fetchin value'

      context 'when the keys case is changed' do
        let(:json)  { full_json['user'] }
        let(:index) { 1 }

        context 'with snake_case type' do
          let(:keys) { %w[user FullName] }
          let(:expected) { json['full_name'] }

          it_behaves_like 'reader fetchin value'
        end

        context 'with upper_camel type' do
          let(:case_type) { :upper_camel }
          let(:keys)     { %w[user login_name] }
          let(:expected) { json['LoginName'] }

          it_behaves_like 'reader fetchin value'
        end

        context 'with lower_camel type' do
          let(:case_type) { :lower_camel }
          let(:keys)     { %w[user birth_date] }
          let(:expected) { json['birthDate'] }

          it_behaves_like 'reader fetchin value'
        end
      end

      context 'when key is found but value is null' do
        let(:json) { full_json['user'] }
        let(:index) { 1 }
        let(:keys)  { %w[user password_reminder] }

        it do
          expect(reader.read(json, index)).to be_nil
        end

        context 'when keys are symbol' do
          it do
            expect(reader.read(sym_json, index)).to be_nil
          end
        end
      end

      context 'when json has both string and symble' do
        let(:keys) { %w[key] }
        let(:json) { { key: 'symbol', 'key' => 'string' } }

        it 'fetches the string key first' do
          expect(reader.read(json, index)).to eq('string')
        end
      end
    end

    context 'when the key is missing' do
      let(:keys) { %w[age] }

      it do
        expect do
          reader.read(json, index)
        end.to raise_error(Arstotzka::Exception::KeyNotFound)
      end
    end
  end

  describe 'ended?' do
    context 'when index is within keys' do
      let(:index) { 1 }

      it { expect(reader).not_to be_ended(index) }
    end

    context 'when index is outside keys' do
      let(:index) { 2 }

      it { expect(reader).to be_ended(index) }
    end
  end
end
