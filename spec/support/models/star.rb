# frozen_string_literal: true

class Star
  attr_reader :name, :color

  def initialize(name:, color: 'yellow')
    @name = name
    @color = color
  end

  def yellow?
    color == 'yellow'
  end

  def ==(other)
    return false unless other.is_a?(self.class)
    other.color == color &&
      other.name == name
  end
end
