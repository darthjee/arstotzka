# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class reponsible for processing the result of {Crawler#crawl}.
  #
  # PostProcessor proccess the whole collection and not
  # individual results
  #
  # @example Simple Usage
  #   class Employe
  #     attr_reader :name, :age, :company
  #
  #     def initialize(name:, age:, company:)
  #       @name    = name
  #       @age     = age
  #       @company = company
  #     end
  #
  #     def adult?
  #       age >= 18
  #     end
  #
  #     def ==(other)
  #       return unless other.class == self.class
  #       other.name == name &&
  #         other.age == age &&
  #         other.company == company
  #     end
  #   end
  #
  #   class Company
  #     def create_employes(people)
  #       people.map do |person|
  #         Employe.new(company: self, **person)
  #       end.select(&:adult?)
  #     end
  #   end
  #
  #   company = Company.new
  #
  #   options = {
  #     after: :create_employes,
  #     flatten: true,
  #     instance: company
  #   }
  #
  #   processor = Arstotzka::PostProcessor.new(options)
  #
  #   value = [
  #     [
  #       { name: 'Bob',   age: 21 },
  #       { name: 'Rose',  age: 19 }
  #     ], [
  #       { name: 'Klara', age: 18 },
  #       { name: 'Al',    age: 15 }
  #     ]
  #   ]
  #
  #   processor.process(value)
  #
  #   # returns [
  #   #   Employe.new(name: 'Bob',   age: 21, company: company),
  #   #   Employe.new(name: 'Rose',  age: 19, company: company),
  #   #   Employe.new(name: 'Klara', age: 18, company: company)
  #   # ]
  class PostProcessor
    include Base

    # @overload initialize(options_hash)
    #   @param options_hash [Hash] options passed by
    #     {ClassMethods#expose}
    #   @option options_hash instance [Objct]
    #   @option options_hash after [String,Symbol] instance method to be called on the
    #     returning value returned by {Crawler} before being returned by {Fetcher}.
    #   @option options_hash flatten [Boolean] flag signallying if multi levels
    #     arrays should be flattened to one level array (applying +Array#flatten+)
    # @overload initialize(options)
    #   @param options [Hash] options passed by {ClassMethods#expose}
    def initialize(options_hash = {})
      self.options = options_hash
    end

    # Apply transformation and filters on the result
    #
    # @param value [Object] value is returned from crawler
    #   being a single object, or an array.
    #
    # @return [Object]
    def process(value)
      value.flatten! if flatten && value.is_a?(Array)

      return value unless after

      instance.send(after, value)
    end

    private

    attr_reader :options

    delegate :instance, :after, :flatten, to: :options
  end
end
