module Arstotzka::TypeCast
  def to_money_float(value)
    value.gsub(/\$ */, '').to_f
  end
end

