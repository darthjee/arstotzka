# frozen_string_literal: true

module Arstotzka
  module TypeCast
    def to_money_float(value)
      value.gsub(/\$ */, '').to_f
    end
  end
end
