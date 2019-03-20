# frozen_string_literal: true

class Group
  def initialize(hash)
    @hash = hash
  end

  private

  def create_person(name)
    Person.new(name)
  end
end
