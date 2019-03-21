# frozen_string_literal: true

class Customer
  attr_reader :name, :age

  def initialize(name:, age:)
    @name = name
    @age  = age
  end

  def adult?
    age >= 18
  end

  def ==(other)
    return false unless other.class == self.class
    other.name == name &&
      other.age == age
  end
end
