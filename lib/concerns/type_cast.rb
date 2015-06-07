module TypeCast
  extend ActiveSupport::Concern

  def to_integer(value)
    return unless value.present?
    value.to_i
  end

  def to_string(value)
    value.to_s
  end

  def to_float(value)
    return unless value.present?
    value.to_f
  end
end
