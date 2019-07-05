# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::Fetcher::Cache do
  subject(:cache) { described_class.new(options) { 100 } }

  let(:instance) { Object.new }
  let(:value)    { cache.fetch }

  let(:options) do
    Arstotzka.config.options(
      options_hash.merge(instance: instance, key: :the_value)
    )
  end

  context 'when option cached is false' do
    let(:options_hash) { { cached: false } }

    context 'when a variable has not been set' do
      it 'returns result of the block' do
        expect(value).to eq(100)
      end

      it 'does not set the variable' do
        expect { value }
          .not_to(change { instance.instance_variable_get(:@the_value) })
      end
    end

    context 'when a variable has been set as nil' do
      before do
        instance.instance_variable_set('@the_value', nil)
      end

      it 'returns result of the block' do
        expect(value).to eq(100)
      end

      it 'does not set the variable' do
        expect { value }
          .not_to(change { instance.instance_variable_get(:@the_value) })
      end
    end

    context 'when a variable has been set with value' do
      before do
        instance.instance_variable_set('@the_value', :old_value)
      end

      it 'returns result of the block' do
        expect(value).to eq(100)
      end

      it 'does not set the variable' do
        expect { value }
          .not_to(change { instance.instance_variable_get(:@the_value) })
      end
    end
  end

  context 'when option cached is true' do
    let(:options_hash) { { cached: true } }

    context 'when a variable has not been set' do
      it 'returns result of the block' do
        expect(value).to eq(100)
      end

      it 'does sets the variable' do
        expect { value }
          .to change { instance.instance_variable_get(:@the_value) }
          .from(nil).to(100)
      end
    end

    context 'when a variable has been set as nil' do
      before do
        instance.instance_variable_set('@the_value', nil)
      end

      it 'returns result of the block' do
        expect(value).to eq(100)
      end

      it 'does sets the variable' do
        expect { value }
          .to change { instance.instance_variable_get(:@the_value) }
          .from(nil).to(100)
      end
    end

    context 'when a variable has been set with value' do
      before do
        instance.instance_variable_set('@the_value', :old_value)
      end

      it 'returns the cached value' do
        expect(value).to eq(:old_value)
      end

      it 'does not update the variable' do
        expect { value }
          .not_to(change { instance.instance_variable_get(:@the_value) })
      end
    end
  end

  context 'when option cached is :full' do
    let(:options_hash) { { cached: :full } }

    context 'when a variable has not been set' do
      it 'returns result of the block' do
        expect(value).to eq(100)
      end

      it 'does sets the variable' do
        expect { value }
          .to change { instance.instance_variable_get(:@the_value) }
          .from(nil).to(100)
      end
    end

    context 'when a variable has been set as nil' do
      before do
        instance.instance_variable_set('@the_value', nil)
      end

      it 'returns nil' do
        expect(value).to be_nil
      end

      it 'does not update the variable' do
        expect { value }
          .not_to(change { instance.instance_variable_get(:@the_value) })
      end
    end

    context 'when a variable has been set with value' do
      before do
        instance.instance_variable_set('@the_value', :old_value)
      end

      it 'returns the cached value' do
        expect(value).to eq(:old_value)
      end

      it 'does not update the variable' do
        expect { value }
          .not_to(change { instance.instance_variable_get(:@the_value) })
      end
    end
  end
end
