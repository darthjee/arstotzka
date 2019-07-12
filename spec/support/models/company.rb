# frozen_string_literal: true

class Company
  def create_employes(people)
    people.map do |person|
      Employe.new(company: self, **person)
    end.select(&:adult?)
  end
end
