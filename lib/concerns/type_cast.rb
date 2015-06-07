module TypeCast
  extend ActiveSupport::Concern

  def to_integer(value)
    value.to_i
  end

  def to_string(value)
    value.to_s
  end

  def to_float(value)
    value.to_f
  end
end
