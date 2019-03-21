# frozen_string_literal: true

class Store
  include Arstotzka

  expose :customers, klass: Customer, after: :filter_adults

  def initialize(json)
    @json = json
  end

  private

  attr_reader :json

  def filter_adults(values)
    values.select(&:adult?)
  end
end
