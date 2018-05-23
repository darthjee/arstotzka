require 'spec_helper'

describe JsonParser::Builder do
  let(:clazz) { Class.new }
  let(:options) { {} }
  let(:attr_name) { :name }
  let(:attr_names) { [ attr_name ] }

  subject do
    described_class.new(attr_names, clazz, options)
  end

  describe '#build' do
    it do
      expect do
        subject.build
      end.to change { clazz.new.respond_to?(attr_name) }
    end
  end
end
