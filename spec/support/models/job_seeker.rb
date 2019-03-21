# frozen_string_literal: true

class JobSeeker
  include Arstotzka

  expose :applicants, case: :snake, default: 'John Doe',
                      full_path: 'applicants.full_name',
                      compact: true, json: :@hash

  def initialize(hash)
    @hash = hash
  end
end
