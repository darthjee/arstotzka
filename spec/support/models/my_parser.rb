# frozen_string_literal: true

class MyParser
  include Arstotzka

  expose :id
  expose :name, :age, path: :person
  expose :total_money, full_path: 'accounts.balance', after: :sum,
                       cached: true, type: :money_float
  expose :total_owed, full_path: 'loans.value', after: :sum,
                      cached: true, type: :money_float

  attr_reader :json

  def initialize(json = {})
    @json = json
  end

  private

  def sum(balances)
    balances&.sum
  end

  models = File.expand_path('spec/support/models/my_parser/*.rb')
  Dir[models].each do |file|
    autoload file.gsub(%r{.*\/(.*)\..*}, '\1').camelize.to_sym, file
  end
end
