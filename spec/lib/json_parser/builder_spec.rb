require 'spec_helper'

describe JsonParser::Builder do
  let(:clazz) do
    Class.new.tap do |c|
      c.send(:attr_reader, :json)
      c.send(:define_method, :initialize) do |json={}|
        @json = json
      end
    end
  end

  let(:options) { {} }
  let(:attr_name) { :name }
  let(:attr_names) { [ attr_name ] }

  subject do
    described_class.new(attr_names, clazz, options)
  end

  describe '#build' do
    it 'adds the reader' do
      expect do
        subject.build
      end.to change { clazz.new.respond_to?(attr_name) }
    end

    context 'when building several attributes' do
      let(:json) { {} }
      let(:attr_names) { [ :id, :name, :age ] }
      let(:instance) { clazz.new(json) }

      before { subject.build }

      it 'adds all the readers' do
        attr_names.each do |attr|
          expect(instance).to respond_to(attr)
        end
      end

      it 'fetches safelly empty jsons' do
        expect(instance.name).to be_nil
      end

      context 'when json has the property' do
        let(:json) { { name: 'Robert' } }

        it 'fetches safelly empty jsons' do
          expect(instance.name).to eq('Robert')
        end

        context 'but key is a string' do
          let(:json) { { 'name' => 'Robert' } }

          it 'fetches safelly empty jsons' do
            expect(instance.name).to eq('Robert')
          end
        end
      end
    end
  end
end
