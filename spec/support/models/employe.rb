# frozen_string_literal: true

class Employe
  attr_reader :name, :age, :company

  def initialize(name:, age:, company:)
    @name    = name
    @age     = age
    @company = company
  end

  def adult?
    age >= 18
  end

  def ==(other)
    return unless other.class == self.class

    other.name == name &&
      other.age == age &&
      other.company == company
  end
end
