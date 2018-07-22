# frozen_string_literal: true

class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(other)
    return false unless other.class == self.class
    other.name == self.name
  end
end
