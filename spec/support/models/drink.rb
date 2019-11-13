# frozen_string_literal: true

class Drink
  attr_reader :name, :price

  def initialize(name:, price:)
    @name  = name
    @price = price
  end

  def inflate(inflation)
    @price = (price * (1 + inflation)).round(2)
  end

  def ==(other)
    return false unless other.class == self.class

    other.name == name &&
      other.price == price
  end
end
