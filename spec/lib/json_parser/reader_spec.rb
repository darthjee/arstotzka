require 'spec_helper'

shared_examples 'reader fetchin value' do
  it do
    expect { subject.read(json, index) }.not_to raise_error
  end

  it do
    expect(subject.read(json, index)).not_to be_nil
  end

  it 'returns the evaluated value' do
    expect(subject.read(json, index)).to eq(expected)
  end

  context 'and the json has symbolized_keys' do
    it 'returns the evaluated value' do
      expect(subject.read(sym_json, index)).to eq(expected)
    end
  end
end

describe JsonParser::Reader do
  subject do
    described_class.new(path: path, case_type: case_type)
  end

  let(:path) { %w(user full_name) }
  let(:json_file) { 'complete_person.json' }
  let(:full_json) { load_json_fixture_file(json_file) }
  let(:json) { full_json  }
  let(:sym_json) { json.symbolize_keys }
  let(:case_type) { :snake }
  let(:index) { 0 }

  describe '#read' do
    context 'when the key is found' do
      let(:expected) { json['user'] }

      it_behaves_like 'reader fetchin value'

      context 'when the path case is changed' do
        let(:json) { full_json['user'] }
        let(:index) { 1 }

        context 'to snake_case' do
          let(:path) { %w(user FullName) }
          let(:expected) { json['full_name'] }

          it_behaves_like 'reader fetchin value'
        end

        context 'to upper_camel' do
          let(:case_type) { :upper_camel }
          let(:path) { %w(user login_name) }
          let(:expected) { json['LoginName'] }

          it_behaves_like 'reader fetchin value'
        end

        context 'to lower_camel' do
          let(:case_type) { :lower_camel }
          let(:path) { %w(user birth_date) }
          let(:expected) { json['birthDate'] }

          it_behaves_like 'reader fetchin value'
        end
      end

      context 'when key is found but value is null' do
        let(:json) { full_json['user'] }
        let(:index) { 1 }
        let(:path) { %w(user password_reminder) }

        it do
          expect(subject.read(json, index)).to be_nil
        end

        context 'but keys are symbol' do
          it do
            expect(subject.read(sym_json, index)).to be_nil
          end
        end
      end

      context 'when json has both string and symble' do
        let(:path) { %w(key) }
        let(:json) { { key: 'symbol', 'key' => 'string' } }

        it 'fetches the string key first' do
          expect(subject.read(json, index)).to eq('string')
        end
      end
    end

    context 'when the key is missing' do
      let(:path) { %w(age) }

      it do
        expect do
          subject.read(json, index)
        end.to raise_error(JsonParser::Exception::KeyNotFound)
      end
    end
  end

  describe 'is_ended?' do
    context 'when index is within path' do
      let(:index) { 1 }

      it { expect(subject.is_ended?(index)).to be_falsey }
    end

    context 'when index is outside path' do
      let(:index) { 2 }

      it { expect(subject.is_ended?(index)).to be_truthy }
    end
  end
end
