class Action
  attr_accessor :rental_id, :who, :type, :amount

  def initialize(rental_id, who, type, amount)
    @rental_id = rental_id
    @who = who
    @type = type
    @amount = amount
  end
end