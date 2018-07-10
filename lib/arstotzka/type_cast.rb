# frozen_string_literal: true

module Arstotzka
  module TypeCast
    extend ActiveSupport::Concern

    def to_integer(value)
      value.to_i if value.present?
    end

    def to_string(value)
      value.to_s
    end

    def to_float(value)
      value.to_f if value.present?
    end
  end
end
