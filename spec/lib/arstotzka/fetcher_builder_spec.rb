# frozen_string_literal: true

require 'spec_helper'

describe Arstotzka::FetcherBuilder do
  subject(:builder) do
    described_class.new instance, options
  end

  let(:instance) { Arstotzka::Fetcher::Dummy.new }
  let(:options)  { { path: 'id' } }
  let(:hash)     { { id: 10 } }

  describe '#build' do
    let(:fetcher) { builder.build(hash) }

    it do
      expect(fetcher).to be_a(Arstotzka::Fetcher)
    end

    it 'builds a fetcher capable of fetching' do
      expect(fetcher.fetch).to eq(10)
    end
  end
end
