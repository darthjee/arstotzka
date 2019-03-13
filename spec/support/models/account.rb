# frozen_string_literal: true

class Account
  def initialize(json = {})
    @json = json
  end

  private

  attr_reader :json

  def filter_income(transactions)
    transactions.select(&:positive?)
  end
end
