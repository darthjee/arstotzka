# frozen_string_literal: true

module Arstotzka
  # Concern with all the type cast methods to be used by {Wrapper}
  #
  # Usage of typecast is defined by the configuration of {Builder} by the usage of
  # option type
  module TypeCast
    extend ActiveSupport::Concern

    # converts a value to integer
    # @return [Integer]
    def to_integer(value)
      value.to_i if value.present?
    end

    # converts value to string
    # @return [String]
    def to_string(value)
      value.to_s
    end

    # converts value to float
    # @return [Float]
    def to_float(value)
      value.to_f if value.present?
    end
  end
end
