# frozen_string_literal: true

class Person
  attr_reader :name, :age

  def initialize(name)
    @name = name
  end

  def ==(other)
    return false unless other.class == self.class

    other.name == name
  end
end
