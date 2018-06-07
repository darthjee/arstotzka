require 'spec_helper'

describe Arstotzka::Builder do
  let(:clazz) do
    Class.new.tap do |c|
      c.send(:attr_reader, :json)
      c.send(:define_method, :initialize) do |json={}|
        @json = json
      end
    end
  end

  let(:options) { {} }
  let(:name) { 'Robert' }
  let(:attr_name) { :name }
  let(:attr_names) { [ attr_name ] }
  let(:json) { {} }
  let(:instance) { clazz.new(json) }

  subject do
    described_class.new(attr_names, clazz, **options)
  end

  describe '#build' do
    it 'adds the reader' do
      expect do
        subject.build
      end.to change { clazz.new.respond_to?(attr_name) }
    end

    context 'after building' do
      before { subject.build }

      context 'when building several attributes' do
        let(:attr_names) { [ :id, :name, :age ] }

        it 'adds all the readers' do
          attr_names.each do |attr|
            expect(instance).to respond_to(attr)
          end
        end

        it 'fetches safelly empty jsons' do
          expect(instance.name).to be_nil
        end

        context 'when json has the property' do
          let(:json) { { name: name } }

          it 'fetches the value' do
            expect(instance.name).to eq(name)
          end

          context 'but key is a string' do
            let(:json) { { 'name' => name } }

            it 'fetches the value' do
              expect(instance.name).to eq(name)
            end
          end
        end
      end

      context 'when value is deep within the json' do
        let(:json) { { user: { name: name } } }

        context 'when defining a path' do
          let(:options) { { path: 'user' } }

          it 'fetches the value within the json' do
            expect(instance.name).to eq(name)
          end
        end

        context 'when defining a fullpath' do
          let(:options) { { full_path: 'user.name' } }
          let(:attr_name) { :the_name }

          it 'fetches the value within the json' do
            expect(instance.the_name).to eq(name)
          end
        end
      end

      context 'when wrapping with a class' do
        let(:json) { { person: name } }
        let(:options) { { class: Person } }
        let(:attr_name) { :person }

        it do
          expect(instance.person).to be_a(Person)
        end

        it 'fills the new instance with the information fetched' do
          expect(instance.person.name).to eq(name)
        end
      end
    end
  end
end
