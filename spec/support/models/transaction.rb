# frozen_string_literal: true

class Transaction
  attr_reader :value, :type

  def initialize(value:, type:)
    @value = value
    @type = type
  end

  def positive?
    type == 'income'
  end

  def ==(other)
    return false unless other.class == self.class

    other.value == value && other.type == type
  end
end
