# frozen_string_literal: true

class NextFlow
  attr_accessor :amount, :bound

  def initialize(amount:, bound:)
    @amount = amount
    @bound = bound
  end

  def overloaded?
    @amount >= @bound
  end
end
