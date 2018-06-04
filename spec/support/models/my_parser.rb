class MyParser
  include Arstotzka

  json_parse :id
  json_parse :name, :age, path: :person
  json_parse :total_money, full_path: 'accounts.balance', after: :sum,
                          cached: true, type: :money_float
  json_parse :total_owed, full_path: 'loans.value', after: :sum,
                          cached: true, type: :money_float

  attr_reader :json

  def initialize(json = {})
    @json = json
  end

  private

  def sum(balances)
    balances.sum if balances
  end

  models = File.expand_path("spec/support/models/my_parser/*.rb")
  Dir[models].each do |file|
    autoload file.gsub(/.*\/(.*)\..*/, '\1').camelize.to_sym, file
  end
end

