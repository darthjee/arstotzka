# frozen_string_literal: true

class Office
  include Arstotzka

  expose :employes, full_path: 'employes.first_name',
                    compact:   true

  def initialize(hash)
    @hash = hash
  end
end
