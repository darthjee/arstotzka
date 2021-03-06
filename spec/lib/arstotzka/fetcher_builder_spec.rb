# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::FetcherBuilder do
  subject(:builder) do
    described_class.new options
  end

  let(:instance) { Arstotzka::Dummy.new(hash) }
  let(:options)  { { path: 'person', key: :id } }

  let(:hash) do
    {
      person: { id: 10 }
    }
  end

  describe '#build' do
    let(:fetcher) { builder.build(instance) }

    it do
      expect(fetcher).to be_a(Arstotzka::Fetcher)
    end

    it 'builds a fetcher capable of fetching' do
      expect(fetcher.fetch).to eq(10)
    end
  end
end
