# frozen_string_literal: true

class Account
  private

  def filter_income(transactions)
    transactions.select(&:positive?)
  end
end
