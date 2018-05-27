module JsonParser::TypeCast
  def to_money_float(value)
    value.gsub(/\$ */, '').to_f
  end
end

class MyParser
  include JsonParser

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
end

