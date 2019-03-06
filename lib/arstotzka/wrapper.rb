# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible for wrapping / parsing a value fetched
  class Wrapper
    include Arstotzka::TypeCast

    # Returns a new instance of Wrapper
    #
    # @param clazz [Class] class to wrap the value
    # @param type [String/Symbol] type to cast the value. The
    #   possible type_cast is defined by {TypeCast}
    def initialize(clazz: nil, type: nil)
      @clazz = clazz
      @type = type
    end

    # wrap a value
    #
    # @return [Object]
    #
    # @example Wrapping in a class
    #   class Person
    #     attr_reader :name
    #
    #     def initialize(name)
    #       @name = name
    #     end
    #   end
    #
    #   wrapper = Arstotzka::Wrapper.new(clazz: Person)
    #   wrapper.wrap('John') # retruns Person.new('John')
    #
    # @example Casting type
    #   wrapper = Arstotzka::Wrapper.new(type: :integer)
    #   wrapper.wrap(['10', '20', '30']) # retruns [10, 20, 30]
    def wrap(value)
      return wrap_array(value) if value.is_a?(Array)
      wrap_element(value)
    end

    private

    # @private
    attr_reader :clazz, :type

    # @private
    #
    # Wraps an element with a class and perform typecasting
    #
    # @return [Object]
    def wrap_element(value)
      value = cast(value) if type? && !value.nil?
      return if value.nil?

      clazz ? clazz.new(value) : value
    end

    # @private
    #
    # Wraps each element of the array
    #
    # @see #wrap_element
    #
    # @return [Arra]
    def wrap_array(array)
      array.map { |v| wrap v }
    end

    # @private
    #
    # Check if type was given
    #
    # @return [Boolean]
    def type?
      type.present? && type != :none
    end

    # @private
    #
    # Performs type casting
    #
    # @see Arstotzka::TypeCaster
    #
    # @return [Object]
    def cast(value)
      public_send("to_#{type}", value)
    end
  end
end
