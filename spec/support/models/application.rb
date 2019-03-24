# frozen_string_literal: true

class Application
  include Arstotzka

  expose :users, full_path: 'users.first_name',
                 compact: true, cached: true,
                 after: :create_person

  def initialize(json)
    @json = json
  end

  private

  attr_reader :json

  def create_person(names)
    names.map do |name|
      warn "Creating person #{name}"
      Person.new(name)
    end
  end
end
