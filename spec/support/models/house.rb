class House
  include Arstotzka
  include ::SafeAttributeAssignment
  attr_reader :json

  expose :age, :value, :floors

  def initialize(json)
    @json = json
  end
end
